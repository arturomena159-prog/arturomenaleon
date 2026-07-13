# Generar snippet de embed (versión compacta) para un proyecto existente — AB Tool
# Uso: .\get-embed-snippet.ps1

$repoRoot = Split-Path -Parent $PSScriptRoot
$abFolder = Join-Path $repoRoot "abtool"

Write-Host ""
Write-Host "=== SNIPPET DE EMBED ===" -ForegroundColor Cyan
Write-Host ""

$slug = Read-Host "Slug del proyecto (la parte random de la URL, ej. boogie-h5p8)"
$manifestPath = Join-Path (Join-Path $abFolder $slug) "manifest.json"

if (-not (Test-Path $manifestPath)) {
    Write-Host "No encontré un proyecto con ese slug ($manifestPath no existe)." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "  Pégalo donde quieras mostrar el comparador (versión compacta):"
Write-Host ""
Write-Host "        <div class=`"ab-embed-wrap fade-in`">" -ForegroundColor Gray
Write-Host "          <iframe class=`"ab-embed-iframe`" src=`"https://arturomenaleon.com/abtool/$slug/?compact=1`" loading=`"lazy`"></iframe>" -ForegroundColor Gray
Write-Host "        </div>" -ForegroundColor Gray
Write-Host ""
Write-Host "  (requiere que la página tenga las clases .ab-embed-wrap / .ab-embed-iframe del CSS del sitio)" -ForegroundColor DarkGray
Write-Host ""
