//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_commons/flutter_commons_plugin_c_api.h>
#include <flutter_secure_storage_windows/flutter_secure_storage_windows_plugin.h>
#include <sentry_flutter/sentry_flutter_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterCommonsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterCommonsPluginCApi"));
  FlutterSecureStorageWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterSecureStorageWindowsPlugin"));
  SentryFlutterPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SentryFlutterPlugin"));
}
