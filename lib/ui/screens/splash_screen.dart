import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/resources/colors.dart';
import '../../core/resources/environment.dart';
import '../components/custom_divider.dart';

///Splash screen to show on root!
///Use this if you got something to do and make some delay or loading when app is open
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: primaryGradient, color: primaryColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/background_world.png',
              fit: BoxFit.fitHeight,
              color: primaryColor,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/logo.png', width: 100, height: 100),
                  const ColumnDivider(space: 20),
                  Text(appName, style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                  const ColumnDivider(space: 5),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("version", textAlign: TextAlign.center, style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white)).tr(args: [snapshot.data!.version]);
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
