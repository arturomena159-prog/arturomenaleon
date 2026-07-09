# Agregar versión (lado B) a un proyecto existente — AB Tool
# Uso: .\add-version.ps1

$repoRoot   = Split-Path -Parent $PSScriptRoot
$abFolder   = Join-Path $repoRoot "abtool"
$scriptsDir = $PSScriptRoot

function Get-R2Credentials {
    $credPath = Join-Path $repoRoot "r2-credentials.txt"
    if (-not (Test-Path $credPath)) { return $null }
    $creds = @{}
    Get-Content $credPath -Encoding UTF8 | ForEach-Object {
        if ($_ -match '^(.+?):\s+(\S.*)$') { $creds[$matches[1].Trim()] = $matches[2].Trim() }
    }
    return $creds
}

function Send-ToR2([string]$localFile, [string]$remoteKey, [hashtable]$creds) {
    $env:R2_ACCESS_KEY_ID     = $creds['Access Key ID']
    $env:R2_SECRET_ACCESS_KEY = $creds['Secret Access Key']
    $env:R2_ENDPOINT          = $creds['S3 Endpoint (Account ID)']
    $env:R2_BUCKET            = $creds['Bucket']

    Push-Location $scriptsDir
    if (-not (Test-Path "node_modules")) {
        Write-Host "  Preparando herramienta de subida (solo la primera vez)..." -ForegroundColor Gray
        npm install --silent 2>&1 | Out-Null
    }
    node "upload-to-r2.mjs" $localFile $remoteKey
    $ok = ($LASTEXITCODE -eq 0)
    Pop-Location
    return $ok
}

Write-Host ""
Write-Host "=== AGREGAR VERSION (lado B) ===" -ForegroundColor Cyan
Write-Host ""

$slug = Read-Host "Slug del proyecto (la parte random de la URL, ej. sultan-x7k2)"
$projectFolder = Join-Path $abFolder $slug
$manifestPath = Join-Path $projectFolder "manifest.json"

if (-not (Test-Path $manifestPath)) {
    Write-Host "No encontré un proyecto con ese slug ($manifestPath no existe)." -ForegroundColor Red
    exit
}

$manifest = Get-Content $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json

$label = Read-Host "¿Cómo se llama esta versión? (ej. Atmos Binaural v2.3, Master Estéreo)"
if ([string]::IsNullOrWhiteSpace($label)) {
    Write-Host "El nombre de la versión es obligatorio." -ForegroundColor Red
    exit
}

$notes = Read-Host "Notas (opcional, Enter para saltar)"
$localFile = Read-Host "Ruta completa al archivo de audio"

if (-not (Test-Path $localFile)) {
    Write-Host "No encontré ese archivo." -ForegroundColor Red
    exit
}

$creds = Get-R2Credentials
if (-not $creds) {
    Write-Host "No encontré r2-credentials.txt — no puedo subir el archivo." -ForegroundColor Red
    exit
}

$existingCount = @($manifest.versions).Count
$tag = "v$($existingCount + 1)"
$ext = [System.IO.Path]::GetExtension($localFile).TrimStart('.')
$remoteKey = "$slug/$tag.$ext"

Write-Host ""
Write-Host "  Subiendo a R2..." -ForegroundColor Gray
$ok = Send-ToR2 -localFile $localFile -remoteKey $remoteKey -creds $creds

if (-not $ok) {
    Write-Host "  Algo falló subiendo el archivo — revisa el mensaje de arriba. No se modificó el manifest." -ForegroundColor Red
    exit
}

$fileUrl = "$($creds['Public URL (r2.dev)'])/$remoteKey"
$today = Get-Date -Format "yyyy-MM-dd"

$newVersion = [ordered]@{
    v     = $tag
    label = $label
    date  = $today
    notes = $notes
    file  = $fileUrl
}

$versionsList = @($manifest.versions) + [pscustomobject]$newVersion
$manifest.versions = $versionsList

$manifest | ConvertTo-Json -Depth 5 | Set-Content -Path $manifestPath -Encoding utf8

Write-Host "  Subida correctamente." -ForegroundColor Green
Write-Host ""
Write-Host "--- VERSION AGREGADA ---" -ForegroundColor Yellow
Write-Host "  Nombre:    $label" -ForegroundColor Green
Write-Host "  Proyecto:  https://arturomenaleon.com/abtool/$slug/" -ForegroundColor Cyan
Write-Host ""
