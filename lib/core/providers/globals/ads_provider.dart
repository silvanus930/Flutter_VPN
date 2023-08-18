import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nerdvpn/core/providers/globals/iap_provider.dart';
import 'package:provider/provider.dart';

import '../../resources/environment.dart';

class AdsProvider extends ChangeNotifier {
  late BuildContext _context;

  static void initialize(BuildContext context) {
    AdsProvider.read(context)._context = context;
  }

  Future<InterstitialAd?> loadInterstitial(String unitId) async {
    if (IAPProvider.read(_context).isPro) return null;
    Completer<InterstitialAd?> completer = Completer<InterstitialAd>();
    InterstitialAd.load(
      adUnitId: unitId,
      request: adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          completer.complete(ad);
          FirebaseAnalytics.instance.logAdImpression();
        },
        onAdFailedToLoad: (error) {
          completer.complete();
        },
      ),
    );
    return completer.future;
  }

  Future<AppOpenAd?> loadOpenAd(String unitId) async {
    return null;
    if (IAPProvider.read(_context).isPro) return null;
    Completer<AppOpenAd?> completer = Completer<AppOpenAd>();
    AppOpenAd.load(
      adUnitId: unitId,
      request: adRequest,
      orientation: AppOpenAd.orientationPortrait,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          completer.complete(ad);
          FirebaseAnalytics.instance.logAdImpression();
        },
        onAdFailedToLoad: (error) {
          completer.complete();
        },
      ),
    );
    return completer.future;
  }

  Future<RewardedInterstitialAd?> loadRewardAd(String unitId) async {
    return null;
    Completer<RewardedInterstitialAd?> completer = Completer();
    RewardedInterstitialAd.load(
      adUnitId: unitId,
      request: adRequest,
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          completer.complete(ad);
          FirebaseAnalytics.instance.logAdImpression();
        },
        onAdFailedToLoad: (error) {
          completer.complete();
        },
      ),
    );
    return completer.future;
  }

  static Widget bannerAd(String unitId, {AdSize adsize = AdSize.banner}) {
    return Container();
    var banner = BannerAd(
      adUnitId: unitId,
      size: adsize,
      listener: BannerAdListener(
        onAdImpression: (ad) {
          FirebaseAnalytics.instance.logAdImpression();
        },
      ),
      request: adRequest,
    );
    return Consumer<IAPProvider>(
      builder: (context, value, child) => value.isPro ? const SizedBox.shrink() : child!,
      child: SizedBox(
        key: Key(unitId),
        height: adsize.height.toDouble(),
        width: adsize.width.toDouble(),
        child: FutureBuilder(
          future: banner.load(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AdWidget(ad: banner);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  static AdsProvider read(BuildContext context) => context.read().._context = context;
  static AdsProvider watch(BuildContext context) => context.read().._context = context;
}
