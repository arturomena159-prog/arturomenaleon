# Generador de proyectos — AB Tool
# Uso: .\new-ab-project.ps1

$repoRoot   = Split-Path -Parent $PSScriptRoot
$abFolder   = Join-Path $repoRoot "abtool"
$scriptsDir = $PSScriptRoot

# --- lee r2-credentials.txt (formato "Clave:   valor" por línea) ---
function Get-R2Credentials {
    $credPath = Join-Path $repoRoot "r2-credentials.txt"
    if (-not (Test-Path $credPath)) { return $null }

    $creds = @{}
    Get-Content $credPath -Encoding UTF8 | ForEach-Object {
        if ($_ -match '^(.+?):\s+(\S.*)$') {
            $creds[$matches[1].Trim()] = $matches[2].Trim()
        }
    }
    return $creds
}

# --- sube un archivo a R2 vía el helper de Node (aws4fetch) ---
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
Write-Host "=== NUEVO PROYECTO A/B ===" -ForegroundColor Cyan
Write-Host ""

$title  = Read-Host "Título de la canción"
$artist = Read-Host "Artista"

if ([string]::IsNullOrWhiteSpace($title) -or [string]::IsNullOrWhiteSpace($artist)) {
    Write-Host "Título y artista son obligatorios." -ForegroundColor Red
    exit
}

$referenceLabel = Read-Host "¿Cómo se llama el lado A? (ej. Maqueta, Master Estéreo — Enter para 'Maqueta')"
if ([string]::IsNullOrWhiteSpace($referenceLabel)) { $referenceLabel = "Maqueta" }

# --- slug: título en minúsculas + 4 caracteres random, ej. "sultan-x7k2" ---
function New-Slug([string]$text) {
    $clean = $text.ToLower()
    $clean = $clean -replace '[áàä]', 'a' -replace '[éèë]', 'e' -replace '[íìï]', 'i' -replace '[óòö]', 'o' -replace '[úùü]', 'u' -replace 'ñ', 'n'
    $clean = $clean -replace '[^a-z0-9]+', '-'
    $clean = $clean.Trim('-')
    $chars = 'abcdefghijklmnopqrstuvwxyz0123456789'
    $rand = -join ((1..4) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
    return "$clean-$rand"
}

$slug = New-Slug $title
$projectFolder = Join-Path $abFolder $slug

if (Test-Path $projectFolder) {
    Write-Host "Ya existe una carpeta con ese slug ($slug) — corre el script otra vez." -ForegroundColor Red
    exit
}

New-Item -ItemType Directory -Path $projectFolder -Force | Out-Null

# --- maqueta: subirla ahora si el usuario da una ruta local ---
$creds = Get-R2Credentials
$referenceUrl = $null

Write-Host ""
$maquetaPath = Read-Host "Ruta completa al archivo del lado A (o Enter para subirlo después)"

if ($maquetaPath -and -not (Test-Path $maquetaPath)) {
    Write-Host "  No encontré ese archivo — seguimos sin subirlo por ahora." -ForegroundColor Yellow
    $maquetaPath = $null
}

if ($maquetaPath -and -not $creds) {
    Write-Host "  No encontré r2-credentials.txt — seguimos sin subirlo por ahora." -ForegroundColor Yellow
    $maquetaPath = $null
}

if ($maquetaPath) {
    $ext = [System.IO.Path]::GetExtension($maquetaPath).TrimStart('.')
    $remoteKey = "$slug/reference.$ext"
    Write-Host "  Subiendo a R2..." -ForegroundColor Gray
    $ok = Send-ToR2 -localFile $maquetaPath -remoteKey $remoteKey -creds $creds
    if ($ok) {
        $referenceUrl = "$($creds['Public URL (r2.dev)'])/$remoteKey"
        Write-Host "  Subida correctamente." -ForegroundColor Green
    } else {
        Write-Host "  Algo falló subiendo el archivo — revisa el mensaje de arriba. Seguimos sin la URL." -ForegroundColor Red
    }
}

if (-not $referenceUrl) {
    $base = if ($creds -and $creds['Public URL (r2.dev)']) { $creds['Public URL (r2.dev)'] } else { 'https://PENDIENTE.r2.dev' }
    $referenceUrl = "$base/$slug/reference.flac"
}

$manifest = [ordered]@{
    id                = $slug
    title             = $title
    artist            = $artist
    genre             = ""
    status            = "in_progress"
    approved_version  = $null
    public            = $false
    reference         = [ordered]@{
        label = $referenceLabel
        file  = $referenceUrl
    }
    versions          = @()
}

$manifestPath = Join-Path $projectFolder "manifest.json"
$manifest | ConvertTo-Json -Depth 5 | Set-Content -Path $manifestPath -Encoding utf8

Write-Host ""
Write-Host "--- PROYECTO CREADO ---" -ForegroundColor Yellow
Write-Host "  Carpeta:   abtool\$slug\" -ForegroundColor Green
Write-Host "  Manifest:  $manifestPath" -ForegroundColor Gray
Write-Host "  URL final: https://arturomenaleon.com/abtool/$slug/" -ForegroundColor Cyan
Write-Host ""

if ($maquetaPath -and $referenceUrl -notmatch 'PENDIENTE') {
    Write-Host "  El lado A ya está en R2, todo listo para probar." -ForegroundColor Green
} else {
    Write-Host "--- PENDIENTE: subir el archivo del lado A ---" -ForegroundColor Yellow
    Write-Host "  Vuelve a correr este script más adelante, o sube el archivo a mano a:"
    Write-Host "    $slug/reference.<extensión> dentro del bucket ab-audio" -ForegroundColor Gray
}
Write-Host ""
Write-Host "  Para agregar una versión del lado B, usa:" -ForegroundColor Yellow
Write-Host "    .\add-version.ps1" -ForegroundColor Gray
Write-Host ""
