import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nerdvpn/core/providers/globals/ads_provider.dart';
import 'package:nerdvpn/core/providers/globals/iap_provider.dart';
import 'package:nerdvpn/core/resources/environment.dart';

import 'package:nerdvpn/ui/components/custom_card.dart';
import 'package:nerdvpn/ui/components/custom_divider.dart';
import 'package:provider/provider.dart';

import '../components/ip_details.dart';

class ConnectionDetailScreen extends StatelessWidget {
  const ConnectionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connection Details"),
      ),
      body: ListView(padding: const EdgeInsets.all(10), children: [
        CustomCard(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          boxShadow: BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
          child: const IpDetailWidget(),
        ),
        const ColumnDivider(),
        Consumer<IAPProvider>(
          builder: (context, value, child) => value.isPro
              ? const SizedBox.shrink()
              : CustomCard(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  boxShadow: BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                  child: AdsProvider.bannerAd(bannerAdUnitID, adsize: AdSize.mediumRectangle),
                ),
        ),
      ]),
    );
  }
}
