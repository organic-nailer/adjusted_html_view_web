import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class AdjustedHtmlViewPlugin extends PlatformInterface {
  AdjustedHtmlViewPlugin() : super(token: _token);
  static final Object _token = Object();

  static void registerWith(Registrar registrar) {
    // dummy
  }
}
