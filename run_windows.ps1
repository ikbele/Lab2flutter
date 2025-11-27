# 1. Créer la structure de dossiers pour flutter_web_auth_2
$pluginPath = "windows\flutter\ephemeral\.plugin_symlinks\flutter_web_auth_2\windows"
New-Item -ItemType Directory -Force -Path "$pluginPath\include\flutter_web_auth_2" | Out-Null

# 2. Créer le fichier none.h
$noneHeader = "// Empty header file for Windows compatibility"
Set-Content -Path "$pluginPath\include\flutter_web_auth_2\none.h" -Value $noneHeader

# 3. Créer le fichier flutter_web_auth_2_plugin_c_api.h
$pluginHeader = @"
#ifndef FLUTTER_PLUGIN_FLUTTER_WEB_AUTH_2_PLUGIN_C_API_H_
#define FLUTTER_PLUGIN_FLUTTER_WEB_AUTH_2_PLUGIN_C_API_H_

#include <flutter_plugin_registrar.h>

#ifdef __cplusplus
extern "C" {
#endif

// Dummy implementation for Windows
__declspec(dllexport) void FlutterWebAuth2PluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  // Empty - plugin not supported on Windows
}

#ifdef __cplusplus
}
#endif

#endif
"@
Set-Content -Path "$pluginPath\include\flutter_web_auth_2\flutter_web_auth_2_plugin_c_api.h" -Value $pluginHeader

# 4. Créer un fichier .cpp vide
$cppFile = @"
// Empty implementation for Windows compatibility
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
"@
Set-Content -Path "$pluginPath\flutter_web_auth_2_plugin.cpp" -Value $cppFile

# 5. Créer un CMakeLists.txt minimal
$cmake = @"
cmake_minimum_required(VERSION 3.14)
set(PROJECT_NAME "flutter_web_auth_2")
project(`${PROJECT_NAME} LANGUAGES CXX)

# Create empty library
add_library(`${PROJECT_NAME} INTERFACE)

set(flutter_web_auth_2_bundled_libraries "" PARENT_SCOPE)
"@
Set-Content -Path "$pluginPath\CMakeLists.txt" -Value $cmake

Write-Host " Fichiers plugin créés" -ForegroundColor Green

# 6. Lancer Flutter
flutter run -d windows
