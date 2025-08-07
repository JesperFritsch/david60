// This file provides JS interop for the PWA install prompt
// Place in lib/pwa_install_helper.dart
import 'dart:js' as js;
import 'dart:html' as html;

class PwaInstallHelper {
  static html.BeforeInstallPromptEvent? _deferredPrompt;

  static void setupListener(void Function() onInstallAvailable) {
    html.window.addEventListener('beforeinstallprompt', (event) {
      event.preventDefault();
      _deferredPrompt = event as html.BeforeInstallPromptEvent;
      onInstallAvailable();
    });
  }

  static Future<void> showInstallPrompt() async {
    if (_deferredPrompt != null) {
      await js.context.callMethod('prompt', []);
      _deferredPrompt = null;
    }
  }

  static bool get isInstallAvailable => _deferredPrompt != null;
}
