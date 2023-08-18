import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';
import 'package:nerdvpn/core/providers/globals/ads_provider.dart';
import 'package:nerdvpn/core/providers/globals/vpn_provider.dart';
import 'package:nerdvpn/core/resources/colors.dart';
import 'package:nerdvpn/core/resources/environment.dart';
import 'package:nerdvpn/core/resources/themes.dart';
import 'package:nerdvpn/core/utils/utils.dart';
import 'package:nerdvpn/ui/components/custom_divider.dart';
import 'package:nerdvpn/ui/components/about_detail.dart';
import 'package:nerdvpn/ui/screens/html_screen.dart';
import 'package:nerdvpn/ui/screens/server_list_screen.dart';
import 'package:nerdvpn/ui/screens/subscription_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/providers/globals/theme_provider.dart';
import '../components/connection_button.dart';
import '../components/custom_image.dart';
import '../components/map_background.dart';
import 'connection_detail_screen.dart';

/// Main screen of the app
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AdvancedDrawerController _controller = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: _controller,
      drawer: ListView(children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("settings", style: Theme.of(context).textTheme.caption).tr(),
              const Divider(),
              ListTile(leading: const Icon(Icons.color_lens), title: const Text('theme_mode').tr(), onTap: () => ThemeProvider.read(context).changeThemeMode(context)),
              ListTile(leading: const Icon(Icons.language), title: const Text('language').tr(), onTap: () => ThemeProvider.read(context).changeLanguage(context)),
              ListTile(leading: const Icon(Icons.update), title: const Text('check_update').tr(), onTap: () => _checkUpdate()),
              const ColumnDivider(space: 20),
              Text("about_us", style: Theme.of(context).textTheme.caption).tr(),
              const Divider(),
              ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('privacy_policy').tr(),
                  onTap: () => startScreen(context, HtmlScreen(title: "privacy_policy".tr(), asset: "assets/html/privacy-policy.html"))),
              ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('terms_of_service').tr(),
                  onTap: () => startScreen(context, HtmlScreen(title: "terms_of_service".tr(), asset: "assets/html/tos.html"))),
              ListTile(leading: const Icon(Icons.info), title: const Text('about').tr(), onTap: () => _aboutClick(context)),
            ],
          ),
        ),
      ]),
      openScale: 0.9,
      openRatio: 0.7,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset("assets/images/background_world.png", fit: BoxFit.cover, color: Colors.grey.withOpacity(.3)),
            ListView(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              children: [
                _appbarWidget(context),
                _connectionInfoWidget(context),
                const ColumnDivider(),
                const Center(child: ConnectionButton()),
                const ColumnDivider(),
                _selectVpnWidget(context),
                const ColumnDivider(space: 20),
                // Center(child: AdsProvider.bannerAd(bannerAdUnitID, adsize: AdSize.mediumRectangle)),
                const ColumnDivider(space: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///Select VPN button, Change the code below if you want to customize the button
  Widget _selectVpnWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("select_vpn_server".tr(), style: Theme.of(context).textTheme.caption),
          const ColumnDivider(space: 5),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _selectVpnClick(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(color: Theme.of(context).dividerColor),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).colorScheme.secondary.withOpacity(0.2), blurRadius: 10, spreadRadius: 2, offset: const Offset(0, 5)),
                ],
              ),
              child: Consumer<VpnProvider>(
                builder: (context, vpnProvider, child) {
                  var config = vpnProvider.vpnConfig;
                  return Row(
                    children: [
                      if (config != null)
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: config.flag.contains("http")
                              ? CustomImage(
                                  url: config.flag,
                                  fit: BoxFit.contain,
                                  borderRadius: BorderRadius.circular(5),
                                )
                              : Image.asset("icons/flags/png/${config.flag}.png", package: "country_icons"),
                        ),
                      const SizedBox(width: 10),
                      Text(config?.name ?? 'select_server'.tr(), style: Theme.of(context).textTheme.bodyText1),
                      const Spacer(),
                      const Icon(Icons.chevron_right),
                      const SizedBox(width: 10),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Connection info widget, Change the code below if you want to customize the widget
  Widget _connectionInfoWidget(BuildContext context) {
    return CupertinoButton(
      onPressed: () => startScreen(context, const ConnectionDetailScreen()),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: primaryColor,
          gradient: const LinearGradient(colors: [primaryColor, secondaryColor], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          boxShadow: [BoxShadow(blurRadius: 20, color: primaryColor.withOpacity(.2))],
          borderRadius: BorderRadius.circular(20),
        ),
        height: 120,
        child: Stack(
          children: [
            //Map background
            const MapBackground(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Connection info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Consumer<VpnProvider>(
                      builder: (context, value, child) {
                        double bytein = 0;
                        double byteout = 0;
                        if ((value.vpnStatus?.byteIn?.trim().isEmpty ?? false) || value.vpnStatus?.byteIn == "0") {
                          bytein = 0;
                        } else {
                          bytein = double.tryParse(value.vpnStatus!.byteIn.toString()) ?? 0;
                        }

                        if ((value.vpnStatus?.byteOut?.trim().isEmpty ?? false) || value.vpnStatus?.byteIn == "0") {
                          byteout = 0;
                        } else {
                          byteout = double.tryParse(value.vpnStatus!.byteOut.toString()) ?? 0;
                        }

                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: const Text("download", style: TextStyle(color: Colors.white, fontSize: 12)).tr()),
                                      const SizedBox(
                                          width: 30, height: 25, child: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.arrow_downward_rounded, size: 20, color: secondaryColor))),
                                    ],
                                  ),
                                  Text("${formatBytes(bytein.floor(), 0)}/s", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                ],
                              ),
                            ),
                            Container(height: 50, width: 1, color: Colors.white, margin: const EdgeInsets.symmetric(horizontal: 15)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: const Text("upload", style: TextStyle(color: Colors.white, fontSize: 12)).tr()),
                                      const SizedBox(
                                          width: 50, height: 25, child: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.arrow_upward_rounded, size: 20, color: secondaryColor))),
                                    ],
                                  ),
                                  Text("${formatBytes(byteout.floor(), 0)}/s", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                //Button to see more detail
                Container(
                  color: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: const Text(
                    "see_more_details",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ).tr(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///Appbar, Change the code below if you want to customize the appbar
  Widget _appbarWidget(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(child: Text(appName, style: textTheme(context).headline6, textAlign: TextAlign.center)),
            Positioned(left: 0, child: IconButton(onPressed: _menuClick, icon: const Icon(Icons.menu))),
            Positioned(
              right: 0,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => _upgradeProClick(context),
                icon: LottieBuilder.asset("assets/animations/crown_free.json"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Open the subscription screen when user click on the crown icon
  void _upgradeProClick(BuildContext context) {
    startScreen(context, const SubscriptionScreen());
  }

  ///Open the menu when user click on the menu icon
  void _menuClick() {
    _controller.showDrawer();
  }

  ///Open the server list screen when user click on the select server button
  void _selectVpnClick(BuildContext context) {
    startScreen(context, const ServerListScreen());
  }

  ///Check for update when user click on the update button
  void _checkUpdate() async {
    if (Platform.isAndroid) {
      checkUpdate(context).then((value) {
        if (!value) {
          NAlertDialog(
            title: const Text("update_not_available").tr(),
            content: const Text("update_not_available_content").tr(),
            blur: 10,
            actions: [TextButton(onPressed: () => closeScreen(context), child: const Text("close").tr())],
          ).show(context);
        }
      });
    } else {
      launchUrlString("https://apps.apple.com/app/id$iosAppID");
    }
  }

  ///Open the about dialog when user click on the about button
  void _aboutClick(BuildContext context) {
    const DialogBackground(dialog: AboutScreen(), blur: 10).show(context);
  }
}
