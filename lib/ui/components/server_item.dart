import 'package:dart_ping/dart_ping.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:nerdvpn/core/models/vpn_config.dart';
import 'package:nerdvpn/core/providers/globals/iap_provider.dart';
import 'package:nerdvpn/core/providers/globals/vpn_provider.dart';
import 'package:nerdvpn/core/resources/colors.dart';
import 'package:nerdvpn/core/utils/utils.dart';
import 'package:nerdvpn/ui/components/custom_divider.dart';
import 'package:nerdvpn/ui/components/custom_image.dart';
import 'package:nerdvpn/ui/screens/subscription_screen.dart';

import '../../core/providers/globals/ads_provider.dart';
import '../../core/resources/environment.dart';

class ServerItem extends StatefulWidget {
  final VpnConfig config;
  const ServerItem(this.config, {super.key});

  @override
  State<ServerItem> createState() => _ServerItemState();
}

class _ServerItemState extends State<ServerItem> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    bool selected = VpnProvider.read(context).vpnConfig?.slug == widget.config.slug;
    super.build(context);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: _itemClick,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(gradient: selected ? secondaryGradient : primaryGradient, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: widget.config.flag.contains("http")
                  ? CustomImage(
                      url: widget.config.flag,
                      fit: BoxFit.contain,
                      borderRadius: BorderRadius.circular(5),
                    )
                  : Image.asset(
                      "icons/flags/png/${widget.config.flag}.png",
                      package: "country_icons",
                    ),
            ),
            const RowDivider(),
            Expanded(child: Text(widget.config.name, style: const TextStyle(color: Colors.white))),
            const RowDivider(),
            if (showSignalStrength)
              FutureBuilder(
                  future: Future.microtask(() => Ping(widget.config.serverIp, count: 1).stream.first),
                  builder: (context, snapshot) {
                    var ms = DateTime.now().difference(now).inMilliseconds;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Image.asset("assets/icons/signal0.png", width: 32, height: 32, color: Colors.grey.shade400);
                    }
                    if (ms < 80) {
                      return Image.asset("assets/icons/signal3.png", width: 32, height: 32);
                    } else if (ms < 150) {
                      return Image.asset("assets/icons/signal2.png", width: 32, height: 32);
                    } else if (ms < 300) {
                      return Image.asset("assets/icons/signal1.png", width: 32, height: 32);
                    } else if (ms > 300) {
                      return Image.asset("assets/icons/signal0.png", width: 32, height: 32);
                    }
                    return Image.asset("assets/icons/signal0.png", width: 32, height: 32, color: Colors.grey);
                  }),
          ],
        ),
      ),
    );
  }

  void _itemClick([bool force = false]) async {
    if (!IAPProvider.read(context).isPro && widget.config.status == 1 && !force) {
      return NAlertDialog(
        blur: 10,
        title: const Text("not_allowed").tr(),
        content: Text(unlockProServerWithRewardAds ? "also_allowed_with_watch_ad_description" : "not_allowed_description").tr(),
        actions: [
          if (unlockProServerWithRewardAds)
            TextButton(
              child: Text("watch_ad".tr()),
              onPressed: () {
                Navigator.pop(context);
                showReward();
              },
            ),
          TextButton(
            child: Text("go_premium".tr()),
            onPressed: () => replaceScreen(context, const SubscriptionScreen()),
          ),
        ],
      ).show(context);
    }
    VpnProvider.read(context).selectServer(context, widget.config).then((value) {
      if (value != null) {
        VpnProvider.read(context).disconnect();
        closeScreen(context);
      }
    });
  }

  void showReward() async {
    CustomProgressDialog customProgressDialog = CustomProgressDialog(context, dismissable: false, onDismiss: () {});

    customProgressDialog.show();

    AdsProvider.read(context).loadRewardAd(interstitialRewardAdUnitID).then((value) async {
      customProgressDialog.dismiss();
      if (value != null) {
        value.show(onUserEarnedReward: (ad, reward) {
          _itemClick(true);
        });
      } else {
        if (unlockProServerWithRewardAdsFail) {
          await NAlertDialog(
            blur: 10,
            title: Text("no_reward_title".tr()),
            content: Text("no_reward_but_unlock_description".tr()),
            actions: [TextButton(child: Text("understand".tr()), onPressed: () => Navigator.pop(context))],
          ).show(context);
          _itemClick(true);
        } else {
          NAlertDialog(
            blur: 10,
            title: Text("no_reward_title".tr()),
            content: Text("no_reward_description".tr()),
            actions: [TextButton(child: Text("understand".tr()), onPressed: () => Navigator.pop(context))],
          ).show(context);
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
