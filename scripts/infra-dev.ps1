# =========================================================
# PayCore - Development Infrastructure
# =========================================================

$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$EnvFile = Join-Path $ProjectRoot "env\.env.dev"

Write-Host "Starting PayCore development infrastructure..." -ForegroundColor Cyan

if (-not (Test-Path $EnvFile)) {
    throw "Environment file not found: $EnvFile"
}

Set-Location $ProjectRoot

docker compose --env-file $EnvFile up -d

Write-Host ""
Write-Host "Infrastructure started." -ForegroundColor Green
Write-Host ""

docker compose --env-file $EnvFile ps