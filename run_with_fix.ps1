param($Command = "run")

Write-Host "=== Fix Flutter Web Auth 2 pour Windows ===" -ForegroundColor Cyan

# Fonction pour créer les fichiers
function Create-PluginFiles {
    $paths = @(
        "windows\flutter\ephemeral\.plugin_symlinks\flutter_web_auth_2\windows\include\flutter_web_auth_2",
        "build\windows\x64\flutter\ephemeral\.plugin_symlinks\flutter_web_auth_2\windows\include\flutter_web_auth_2"
    )
    
    $noneHeader = @"
#ifndef FLUTTER_WEB_AUTH_2_NONE_H_
#define FLUTTER_WEB_AUTH_2_NONE_H_

#include <flutter/plugin_registrar_windows.h>

inline void noneRegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar) {
  // Empty implementation
}

#endif
"@
    
    foreach ($path in $paths) {
        New-Item -ItemType Directory -Force -Path $path | Out-Null
        Set-Content -Path "$path\none.h" -Value $noneHeader -Force
        Write-Host " Créé: $path\none.h" -ForegroundColor Green
    }
}

# Créer les fichiers avant le build
Create-PluginFiles

# Lancer flutter dans un job en arrière-plan pour pouvoir intervenir
$job = Start-Job -ScriptBlock {
    param($dir)
    Set-Location $dir
    flutter run -d windows
} -ArgumentList (Get-Location)

# Attendre un peu pour que Flutter initialise
Start-Sleep -Seconds 3

# Re-créer les fichiers pendant le build
Create-PluginFiles

# Attendre le job
Receive-Job -Job $job -Wait -AutoRemoveJob
