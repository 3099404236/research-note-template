param(
  [string]$Message = "Update research note",
  [string]$HomepageRepo = "..\3099404236.github.io",
  [string]$HomepagePdfPath = "papers\example-llm-conversation-stance.pdf",
  [string]$PublicPdfUrl = "https://3099404236.github.io/papers/example-llm-conversation-stance.pdf",
  [int[]]$RenderPages = @(),
  [switch]$RenderAll,
  [switch]$LocalOnly,
  [switch]$SkipHomepage,
  [switch]$SkipWait
)

$ErrorActionPreference = "Stop"

function Invoke-Checked {
  param(
    [Parameter(Mandatory = $true)][string]$FilePath,
    [string[]]$Arguments = @()
  )
  & $FilePath @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "Command failed with exit code ${LASTEXITCODE}: $FilePath $($Arguments -join ' ')"
  }
}

function Get-TypstPath {
  $cmd = Get-Command typst -ErrorAction SilentlyContinue
  if ($cmd) { return $cmd.Source }

  $wingetRoot = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages"
  $matches = Get-ChildItem -Path $wingetRoot -Recurse -Filter typst.exe -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending
  if ($matches) { return $matches[0].FullName }

  throw "typst was not found. Install Typst or add typst.exe to PATH."
}

function Get-PdftoppmPath {
  $miktex = Join-Path $env:LOCALAPPDATA "Programs\MiKTeX\miktex\bin\x64\pdftoppm.exe"
  if (Test-Path -LiteralPath $miktex) { return $miktex }

  $cmd = Get-Command pdftoppm -ErrorAction SilentlyContinue
  if ($cmd) { return $cmd.Source }

  return $null
}

function Get-GitHubRepoSlug {
  $slug = (& gh repo view --json nameWithOwner --jq ".nameWithOwner" 2>$null)
  if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($slug)) {
    return $null
  }
  return $slug.Trim()
}

function Wait-LatestRun {
  param([string]$RepoSlug)
  if ($SkipWait -or [string]::IsNullOrWhiteSpace($RepoSlug)) { return }

  Start-Sleep -Seconds 4
  $runId = (& gh run list --repo $RepoSlug --limit 1 --json databaseId --jq ".[0].databaseId" 2>$null)
  if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($runId)) {
    Write-Host "No GitHub Actions run found for $RepoSlug."
    return
  }
  Invoke-Checked "gh" @("run", "watch", $runId.Trim(), "--repo", $RepoSlug, "--exit-status")
}

function Has-GitChanges {
  $status = (& git status --porcelain)
  return -not [string]::IsNullOrWhiteSpace(($status -join "`n"))
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Push-Location $repoRoot
try {
  $typst = Get-TypstPath
  Write-Host "Compiling paper/main.typ -> paper/main.pdf"
  Invoke-Checked $typst @("compile", "paper/main.typ", "paper/main.pdf")

  if ($RenderAll -or $RenderPages.Count -gt 0) {
    $pdftoppm = Get-PdftoppmPath
    if (-not $pdftoppm) {
      Write-Host "pdftoppm not found; skipping PNG render."
    } else {
      $renderDir = Join-Path $repoRoot ".workbuddy\publish-render"
      if (Test-Path -LiteralPath $renderDir) {
        Remove-Item -LiteralPath $renderDir -Recurse -Force
      }
      New-Item -ItemType Directory -Force -Path $renderDir | Out-Null

      if ($RenderAll) {
        Invoke-Checked $pdftoppm @("-png", "paper/main.pdf", (Join-Path $renderDir "page"))
      } else {
        foreach ($page in $RenderPages) {
          Invoke-Checked $pdftoppm @("-f", "$page", "-l", "$page", "-png", "paper/main.pdf", (Join-Path $renderDir "page-$page"))
        }
      }
      Write-Host "Rendered PNG pages under $renderDir"
    }
  }

  if ($LocalOnly) {
    Write-Host "LocalOnly set; stopping before git publish."
    exit 0
  }

  $repoSlug = Get-GitHubRepoSlug
  Invoke-Checked "git" @("pull", "--ff-only")

  if (Has-GitChanges) {
    Invoke-Checked "git" @("add", "-A")
    Invoke-Checked "git" @("commit", "-m", $Message)
    Invoke-Checked "git" @("push")
  } else {
    Write-Host "No template repository changes to commit."
  }

  Wait-LatestRun $repoSlug

  if (-not $SkipHomepage) {
    $homepageRoot = Resolve-Path (Join-Path $repoRoot $HomepageRepo)
    $sourcePdf = Join-Path $repoRoot "paper\main.pdf"
    $targetPdf = Join-Path $homepageRoot $HomepagePdfPath
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $targetPdf) | Out-Null
    Copy-Item -LiteralPath $sourcePdf -Destination $targetPdf -Force

    Push-Location $homepageRoot
    try {
      $homepageSlug = Get-GitHubRepoSlug
      Invoke-Checked "git" @("pull", "--ff-only")
      if (Has-GitChanges) {
        Invoke-Checked "git" @("add", $HomepagePdfPath)
        Invoke-Checked "git" @("commit", "-m", "Sync research note PDF")
        Invoke-Checked "git" @("push")
        Wait-LatestRun $homepageSlug
      } else {
        Write-Host "No homepage PDF changes to commit."
      }
    } finally {
      Pop-Location
    }

    if (-not [string]::IsNullOrWhiteSpace($PublicPdfUrl)) {
      $response = Invoke-WebRequest -Uri $PublicPdfUrl -UseBasicParsing -Method Head
      Write-Host "Public PDF: $($response.StatusCode) $PublicPdfUrl"
    }
  }
} finally {
  Pop-Location
}
