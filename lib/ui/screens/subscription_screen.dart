import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/modules.dart';
import 'package:lottie/lottie.dart';
import 'package:nerdvpn/core/providers/globals/iap_provider.dart';
import 'package:nerdvpn/core/resources/colors.dart';
import 'package:nerdvpn/core/resources/environment.dart';
import 'package:nerdvpn/ui/components/custom_card.dart';
import 'package:nerdvpn/ui/components/custom_divider.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: primaryGradient.colors, begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: const CloseButton(),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/background_world.png',
              fit: BoxFit.fitHeight,
              color: primaryColor,
            ),
            Consumer<IAPProvider>(
              builder: (context, value, child) {
                return Center(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text(
                        "subscription_title",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
                      ).tr(),
                      const ColumnDivider(),
                      LottieBuilder.asset("assets/animations/crown_pro.json", width: 100, height: 100),
                      const ColumnDivider(),
                      Text(
                        "subscription_description",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey.shade300),
                      ).tr(),
                      const ColumnDivider(space: 20),
                      ...value.productItems.map((e) => _subsButton(value, e)).toList(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _subsButton(IAPProvider provider, IAPItem e) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        provider.purchase(e);
      },
      child: SizedBox(
        height: 100,
        child: CustomCard(
          margin: const EdgeInsets.symmetric(vertical: 5),
          showOnOverflow: false,
          child: Stack(
            children: [
              if (subscriptionIdentifier[e.productId]!["featured"])
                const Positioned(
                  right: 0,
                  child: Banner(
                    message: "featured",
                    location: BannerLocation.topEnd,
                    color: primaryColor,
                  ),
                ),
              Center(
                child: ListTile(
                  title: Text(subscriptionIdentifier[e.productId]!["name"]),
                  subtitle: Text(e.description ?? ""),
                  trailing: Text(e.localizedPrice ?? ""),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
