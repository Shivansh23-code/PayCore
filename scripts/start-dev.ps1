# =========================================================
# PayCore - Development Startup Script
# =========================================================

$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$EnvFile = Join-Path $ProjectRoot "env\.env.dev"

Write-Host "Starting PayCore in DEVELOPMENT mode..." -ForegroundColor Cyan

if (-not (Test-Path $EnvFile)) {
    throw "Environment file not found: $EnvFile"
}

# Load environment variables
Get-Content $EnvFile | ForEach-Object {

    $Line = $_.Trim()

    # Ignore empty lines and comments
    if ($Line -eq "" -or $Line.StartsWith("#")) {
        return
    }

    $Parts = $Line -split "=", 2

    if ($Parts.Count -eq 2) {
        $Name = $Parts[0].Trim()
        $Value = $Parts[1].Trim()

        [Environment]::SetEnvironmentVariable(
            $Name,
            $Value,
            "Process"
        )
    }
}

# Select Spring profile
$env:SPRING_PROFILES_ACTIVE = "dev"

# PostgreSQL JDBC sends the JVM default timezone while opening a connection.
# Preserve existing JVM options and append UTC for the local application process.
$UtcJvmOption = "-Duser.timezone=UTC"
if ([string]::IsNullOrWhiteSpace($env:JAVA_TOOL_OPTIONS)) {
    $env:JAVA_TOOL_OPTIONS = $UtcJvmOption
} elseif ($env:JAVA_TOOL_OPTIONS -notmatch "(^|\s)-Duser\.timezone=UTC(\s|$)") {
    $env:JAVA_TOOL_OPTIONS = "$($env:JAVA_TOOL_OPTIONS.Trim()) $UtcJvmOption"
}

Write-Host "DB Host: $env:PAYCORE_DB_HOST" -ForegroundColor Yellow
Write-Host "DB Port: $env:PAYCORE_DB_PORT" -ForegroundColor Yellow
Write-Host "DB Name: $env:PAYCORE_DB_NAME" -ForegroundColor Yellow
Write-Host "DB User: $env:PAYCORE_DB_USERNAME" -ForegroundColor Yellow
Write-Host "DB Password Loaded: $([string]::IsNullOrEmpty($env:PAYCORE_DB_PASSWORD) -eq $false)" -ForegroundColor Yellow
Write-Host "Environment: development" -ForegroundColor Green
Write-Host "Starting Spring Boot..." -ForegroundColor Green

Set-Location $ProjectRoot

& ".\mvnw.cmd" spring-boot:run
