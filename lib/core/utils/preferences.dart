import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/vpn_config.dart';

class Preferences {
  final SharedPreferences shared;

  Preferences(this.shared);

  set token(String? value) => shared.setString("token", value!);

  String? get token => shared.getString("token");

  static Future<Preferences> instance() => SharedPreferences.getInstance().then((value) => Preferences(value));

  void saveServers({required List<VpnConfig> value}) {
    shared.setString("server_cache", jsonEncode(value.map((e) => e.toJson()).toList()));
  }

  void setServer(VpnConfig? value) {
    if (value == null) {
      shared.remove("server");
      return;
    }
    shared.setString("server", jsonEncode(value.toJson()));
  }

  VpnConfig? getServer() {
    final server = shared.getString("server");
    if (server != null) {
      return VpnConfig.fromJson(jsonDecode(server));
    }
    return null;
  }

  List<VpnConfig> loadServers() {
    var data = shared.getString("server_cache");
    if (data != null) {
      return (jsonDecode(data) as List).map((e) => VpnConfig.fromJson(e)).toList();
    }
    return [];
  }
}
