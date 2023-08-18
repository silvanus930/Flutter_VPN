import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/globals/vpn_provider.dart';
import '../../core/utils/utils.dart';

class MapBackground extends StatelessWidget {
  const MapBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnProvider>(
      builder: (context, provider, child) {
        if (provider.vpnConfig == null) {
          return Image.asset(
            "assets/images/maps/world.png",
            height: 150,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            color: Colors.grey.shade100.withOpacity(.3),
          );
        }
        return FutureBuilder<bool>(
          future: assetExists("assets/images/maps/${provider.vpnConfig?.flag.toLowerCase()}.png"),
          builder: (context, snapshot2) {
            if (snapshot2.data ?? false) {
              return Image.asset(
                "assets/images/maps/${provider.vpnConfig?.flag.toLowerCase()}.png",
                height: 150,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
                color: Colors.grey.shade100.withOpacity(.2),
              );
            } else {
              return Image.asset(
                "assets/images/maps/world.png",
                height: 150,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                color: Colors.grey.shade100.withOpacity(.3),
              );
            }
          },
        );
      },
    );
  }
}
