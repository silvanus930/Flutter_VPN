// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nerdvpn/core/providers/globals/iap_provider.dart';
import 'package:nerdvpn/core/resources/environment.dart';
import 'package:nerdvpn/core/utils/utils.dart';
import 'core/providers/globals/ads_provider.dart';
import 'ui/screens/main_screen.dart';
import 'ui/screens/splash_screen.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> with WidgetsBindingObserver {
  bool _ready = false;
  AppOpenAd? _appOpenAd;
  Timer? openAdTimeout;

  DateTime _lastShownTime = DateTime.now();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(const Duration(seconds: 5)).then((value) {
        if (!_ready) {
          setState(() {
            _ready = true;
          });
        }
      });
      await IAPProvider.read(context).initialize().catchError((_) {});
      await loadAppOpenAd().then((value) => _appOpenAd?.showIfNotPro(context)).catchError((_) {});
      setState(() {
        _ready = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    openAdTimeout?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_lastShownTime.difference(DateTime.now()).inMinutes > 5) {
        _appOpenAd?.showIfNotPro(context);
        _lastShownTime = DateTime.now();
      }
    } else if (state == AppLifecycleState.paused) {
      loadAppOpenAd();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return _ready ? const MainScreen() : const SplashScreen();
  }

  Future loadAppOpenAd() async {
    openAdTimeout?.cancel();
    return AdsProvider.read(context).loadOpenAd(openAdUnitID).then((value) {
      if (value != null) {
        _appOpenAd = value;
        _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            _appOpenAd!.dispose();
            _appOpenAd = null;
            loadAppOpenAd();
          },
        );
      } else {
        openAdTimeout = Timer(const Duration(minutes: 1), loadAppOpenAd);
      }
      return value;
    });
  }
}
