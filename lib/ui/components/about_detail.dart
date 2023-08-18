import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nerdvpn/core/resources/colors.dart';
import 'package:nerdvpn/core/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/resources/environment.dart';
import 'custom_card.dart';
import 'custom_divider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomCard(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Image.asset("assets/images/about_ilustration.png", height: 200)),
            const ColumnDivider(space: 20),
            Text(
              appName,
              style: Theme.of(context).textTheme.headline5!.copyWith(color: primaryColor, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("version", textAlign: TextAlign.center, style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.bold)).tr(args: [snapshot.data!.version]);
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const ColumnDivider(space: 10),
            Text(
              "about_description",
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.bodySmall,
            ).tr(namedArgs: {"name": appName}),
            const ColumnDivider(space: 10),
            SizedBox(
              height: 50,
              child: TextButton(
                onPressed: () => closeScreen(context),
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                  backgroundColor: primaryColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("close").tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
