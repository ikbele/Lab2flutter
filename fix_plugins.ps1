#!/usr/bin/env pwsh

# Attendre que le fichier soit généré
Start-Sleep -Seconds 2

# Modifier le fichier generated_plugin_registrant.cc
$registrantFile = "windows/flutter/generated_plugin_registrant.cc"
if (Test-Path $registrantFile) {
    $lines = Get-Content $registrantFile | Where-Object { $_ -notmatch "flutter_web_auth_2" }
    $lines | Set-Content $registrantFile
    Write-Host "Fichier registrant modifié!" -ForegroundColor Green
}
