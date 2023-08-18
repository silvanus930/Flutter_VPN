import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:nerdvpn/core/https/servers_http.dart';
import 'package:nerdvpn/core/models/vpn_config.dart';
import 'package:nerdvpn/core/utils/preferences.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:provider/provider.dart';

import '../../resources/environment.dart';

class VpnProvider extends ChangeNotifier {
  VPNStage? vpnStage;
  VpnStatus? vpnStatus;
  VpnConfig? _vpnConfig;

  VpnConfig? get vpnConfig => _vpnConfig;
  set vpnConfig(VpnConfig? value) {
    _vpnConfig = value;
    Preferences.instance().then((prefs) {
      prefs.setServer(value);
    });
    notifyListeners();
  }

  ///VPN engine
  late OpenVPN engine;

  ///Check if VPN is connected
  bool get isConnected => vpnStage == VPNStage.connected;

  ///Initialize VPN engine and load last server
  void initialize(BuildContext context) {
    engine = OpenVPN(onVpnStageChanged: onVpnStageChanged, onVpnStatusChanged: onVpnStatusChanged)
      ..initialize(
        lastStatus: onVpnStatusChanged,
        lastStage: (stage) => onVpnStageChanged(stage, stage.name),
        groupIdentifier: groupIdentifier,
        localizedDescription: localizationDescription,
        providerBundleIdentifier: providerBundleIdentifier,
      );

    Preferences.instance().then((value) async {
      vpnConfig = value.getServer() ?? await ServersHttp(context).random();
      notifyListeners();
    });
  }

  ///VPN status changed
  void onVpnStatusChanged(VpnStatus? status) {
    vpnStatus = status;
    notifyListeners();
  }

  ///VPN stage changed
  void onVpnStageChanged(VPNStage stage, String rawStage) {
    vpnStage = stage;
    if (stage == VPNStage.error) {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        vpnStage = VPNStage.disconnected;
      });
    }
    notifyListeners();
  }

  ///Connect to VPN server
  void connect() async {
    log("${vpnConfig?.config}");
    String? config;
    try {
      config = await OpenVPN.filteredConfig(vpnConfig?.config);
    } catch (e) {
      config = vpnConfig?.config;
    }
    if (config == null) return;
    engine.connect(
      config,
      vpnConfig!.name,
      certIsRequired: certificateVerify,
      username: vpnConfig!.username ?? vpnUsername,
      password: vpnConfig!.password ?? vpnPassword,
    );
  }

  ///Select server from list
  Future<VpnConfig?> selectServer(BuildContext context, VpnConfig config) async {
    return ServersHttp(context).serverDetail(config.slug).showCustomProgressDialog(context).then((value) {
      if (value != null) {
        vpnConfig = value;
        notifyListeners();
        return value;
      }
      return null;
    });
  }

  ///Disconnect from VPN server if connected
  void disconnect() {
    engine.disconnect();
  }

  static VpnProvider watch(BuildContext context) => context.watch();
  static VpnProvider read(BuildContext context) => context.read();
}
