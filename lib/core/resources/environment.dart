import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

//TODO: Put your endpoint and vpn auth here
const String endpoint = "https://nerd-vpn.laskarmedia.id/api/";
const String vpnUsername = "";
const String vpnPassword = "";
const bool certificateVerify = true; //Turn it on if you use certificate

const String appName = "AUTO VPN";

///TODO: Default theme mode
ThemeMode themeMode = ThemeMode.system;
bool allowUserChangeTheme = true;

///TODO: Add your supported locales here
List<Locale> supportedLocales = const [
  Locale('en', 'US'), //English
  Locale('in', 'ID'), //Indonesia
];

//TODO: Show signal strength on server list
const bool showSignalStrength = true;

//TODO: Store server list in local storage and show it when offline (not recommended)
const bool cacheServerList = true;

//TODO: iOS setup
const String providerBundleIdentifier = "com.nerdvpn.vpn";
const String groupIdentifier = "group.com.nerdvpn.nerdvpn";
const String iosAppID = "1234567890";
const String localizationDescription = "Nerd VPN - Fast & Secure VPN";

///TODO: Customize your adRequest here
AdRequest get adRequest => const AdRequest();

///TODO: Allow user to unlock pro server with reward ads
bool unlockProServerWithRewardAds = true;

///TODO: Keep unlock pro server while reward ads fail to load
///TODO: By activate this, user can unlock pro server even if reward ads fail to load
bool unlockProServerWithRewardAdsFail = false;

///TODO: Set your ad unit id here
const String interstitialAdUnitID = "ca-app-pub-3940256099942544/1033173712";
const String bannerAdUnitID = "ca-app-pub-3940256099942544/6300978111";
const String interstitialRewardAdUnitID = "ca-app-pub-3940256099942544/5354046379";
const String openAdUnitID = "ca-app-pub-3940256099942544/3419835294";

///TODO: Set your custom subscription identifier here
const Map<String, Map<String, dynamic>> subscriptionIdentifier = {
  // "one_week_subs": { //This is your subscription id
  //   "name": "One Week Subscription", //This is your subscription name
  //   "duration": Duration(days: 7), //This is your subscription duration
  //   "grace_period": Duration(days: 1), //This is your subscription grace period
  //   "featured": false, //This is your subscription if it featured or not
  // },
  "one_week_subs": {
    "name": "One Week Subscription", //This is your subscription name
    "duration": Duration(days: 7), //This is your subscription duration
    "grace_period": Duration(days: 1), //This is your subscription grace period
    "featured": false, //This is your subscription if it featured or not
  },
  "one_month_subs": {
    "name": "One Month Subscription",
    "duration": Duration(days: 30),
    "grace_period": Duration(days: 7),
    "featured": true,
  },
  "one_year_subs": {
    "name": "One Year Subscription",
    "duration": Duration(days: 365),
    "grace_period": Duration(days: 7),
    "featured": false,
  },
};
