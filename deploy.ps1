<#
  deploy.ps1 — Deploy da galeria Novos Ares Luar (Tenda) para o AWS S3.

  Uso:
    ./deploy.ps1             # sync completo + cache-control no HTML/JS
    ./deploy.ps1 -QuickHtml  # atualiza só index.html e inject.js (rápido)

  Pré-requisitos (uma única vez):
    1. AWS CLI instalado  -> https://aws.amazon.com/cli/
    2. Credenciais        -> aws configure   (regiao: sa-east-1)
#>

param(
  [switch]$QuickHtml
)

$ErrorActionPreference = 'Stop'
$Bucket = 's3://skylineip/Tour Virtual/TENDA/ferramentas/galeria/novos ares luar'
$NoCache = 'no-cache,no-store,must-revalidate'

Set-Location -Path $PSScriptRoot

if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
  Write-Host 'ERRO: AWS CLI nao encontrado no PATH.' -ForegroundColor Red
  Write-Host 'Instale em https://aws.amazon.com/cli/ e rode "aws configure".' -ForegroundColor Yellow
  exit 1
}

function Copy-Html($file) {
  Write-Host "  -> $file" -ForegroundColor Cyan
  aws s3 cp $file "$Bucket/$file" --cache-control $NoCache
}

if ($QuickHtml) {
  Write-Host 'Atualizando apenas HTML/JS...' -ForegroundColor Green
  Copy-Html 'index.html'
  Copy-Html 'inject.js'
}
else {
  Write-Host 'Sync completo para o S3...' -ForegroundColor Green

  # Sobe SO o que a galeria consome (assets/web). Ficam de fora os originais
  # entregues (assets/Lazer, assets/Plantas, assets/apartamento) e scripts/docs.
  aws s3 sync . "$Bucket/" `
    --exclude "*" `
    --include "index.html" --include "inject.js" `
    --include "assets/web/*" `
    --exclude "*Thumbs.db" `
    --delete

  # HTML/JS precisam de cache-control para o 3DVista nunca servir versao cacheada
  Write-Host 'Aplicando cache-control no HTML/JS...' -ForegroundColor Green
  Copy-Html 'index.html'
  Copy-Html 'inject.js'
}

Write-Host 'Deploy concluido.' -ForegroundColor Green
Write-Host "Base: https://skylineip.s3.sa-east-1.amazonaws.com/Tour+Virtual/TENDA/ferramentas/galeria/novos+ares+luar/" -ForegroundColor DarkGray
