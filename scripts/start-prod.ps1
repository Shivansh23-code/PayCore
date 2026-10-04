# =========================================================
# PayCore - Production Startup Script
# =========================================================

$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$EnvFile = Join-Path $ProjectRoot "env\.env.prod"

Write-Host "Starting PayCore in PRODUCTION mode..." -ForegroundColor Yellow

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
$env:SPRING_PROFILES_ACTIVE = "prod"

# PostgreSQL JDBC sends the JVM default timezone while opening a connection.
# Preserve existing JVM options and append UTC for the production process.
$UtcJvmOption = "-Duser.timezone=UTC"
if ([string]::IsNullOrWhiteSpace($env:JAVA_TOOL_OPTIONS)) {
    $env:JAVA_TOOL_OPTIONS = $UtcJvmOption
} elseif ($env:JAVA_TOOL_OPTIONS -notmatch "(^|\s)-Duser\.timezone=UTC(\s|$)") {
    $env:JAVA_TOOL_OPTIONS = "$($env:JAVA_TOOL_OPTIONS.Trim()) $UtcJvmOption"
}

Write-Host "Environment: production" -ForegroundColor Green
Write-Host "Starting Spring Boot..." -ForegroundColor Green

Set-Location $ProjectRoot

& ".\mvnw.cmd" spring-boot:run
