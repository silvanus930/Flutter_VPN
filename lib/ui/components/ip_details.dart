import 'package:flutter/material.dart';

import 'package:nerdvpn/core/https/servers_http.dart';
import 'package:nerdvpn/core/resources/themes.dart';

import '../../core/models/ip_detail.dart';
import '../../core/utils/utils.dart';
import 'custom_divider.dart';
import 'custom_shimmer.dart';

class IpDetailWidget extends StatelessWidget {
  const IpDetailWidget({Key? key, this.callback}) : super(key: key);

  final Function(IpDetail value)? callback;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<IpDetail?>(
      future: ServersHttp(context).getPublicIP(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _loading();
        var ipDetail = snapshot.data;
        return Stack(
          children: [
            Positioned(
              right: 10,
              width: MediaQuery.of(context).size.width / 2,
              child: FutureBuilder<bool>(
                future: assetExists("assets/images/maps/${snapshot.data!.yourFuckingCountryCode.toLowerCase()}.png"),
                builder: (context, snapshot2) {
                  if (snapshot2.connectionState == ConnectionState.waiting && !snapshot2.hasData) return const SizedBox(height: 150);
                  if (snapshot2.data ?? false) {
                    return Image.asset(
                      "assets/images/maps/${snapshot.data!.yourFuckingCountryCode.toLowerCase()}.png",
                      height: 150,
                      color: Colors.grey.withOpacity(.6),
                    );
                  } else {
                    return Image.asset(
                      "assets/images/maps/world.png",
                      height: 150,
                      color: Colors.grey.withOpacity(.6),
                    );
                  }
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                detail(
                  context,
                  "Country",
                  "${ipDetail?.yourFuckingCountry ?? "N/A"} - ${ipDetail?.yourFuckingCountryCode ?? "N/A"}",
                  valueLead: Image.asset("icons/flags/png/${ipDetail?.yourFuckingCountryCode.toLowerCase()}.png", package: "country_icons", width: 20),
                ),
                const ColumnDivider(),
                detail(
                  context,
                  "Ip Address",
                  ipDetail?.yourFuckingIpAddress ?? "N/A",
                  valueLead: Icon(Icons.network_wifi, size: 20, color: textTheme(context).bodyText1!.color),
                ),
                const ColumnDivider(),
                detail(
                  context,
                  "Hostname",
                  ipDetail?.yourFuckingHostname ?? "N/A",
                  valueLead: Icon(Icons.golf_course_outlined, size: 20, color: textTheme(context).bodyText1!.color),
                ),
                const ColumnDivider(),
                detail(
                  context,
                  "ISP",
                  ipDetail?.yourFuckingIsp ?? "N/A",
                  valueLead: Icon(Icons.business, size: 20, color: textTheme(context).bodyText1!.color),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _loading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        objShimmer(),
        const ColumnDivider(),
        objShimmer(),
        const ColumnDivider(),
        objShimmer(),
        const ColumnDivider(),
        objShimmer(),
      ],
    );
  }

  Widget detail(BuildContext context, String title, String value, {Widget? valueLead}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: textTheme(context).caption),
        const ColumnDivider(space: 5),
        SizedBox(
          child: Row(
            children: [
              if (valueLead != null) ...[
                SizedBox(width: 30, child: CircleAvatar(backgroundColor: Colors.grey.withOpacity(.1), child: valueLead)),
                const RowDivider(space: 5),
              ],
              Expanded(child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ],
    );
  }

  Widget objShimmer() {
    return ShimmerContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Align(alignment: Alignment.centerLeft, child: ShimmerObject(height: 14, width: 30)),
          ColumnDivider(space: 5),
          Align(alignment: Alignment.centerLeft, child: ShimmerObject(height: 14, width: 80)),
        ],
      ),
    );
  }
}
