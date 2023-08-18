import 'package:easy_localization/easy_localization.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nerdvpn/core/https/servers_http.dart';
import 'package:nerdvpn/core/models/vpn_config.dart';
import 'package:nerdvpn/core/resources/environment.dart';
import 'package:nerdvpn/core/utils/preferences.dart';
import 'package:nerdvpn/ui/components/server_item.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

/// Server list screen
class ServerListScreen extends StatefulWidget {
  const ServerListScreen({super.key});

  @override
  State<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends State<ServerListScreen> {
  final List<RefreshController> _refreshControllers = List.generate(2, (index) => RefreshController(initialRefresh: !cacheServerList));
  List<VpnConfig> _servers = [];

  @override
  void initState() {
    ServicesBinding.instance.addPostFrameCallback((timeStamp) {
      if (cacheServerList) {
        Preferences.instance().then((value) {
          if (value.loadServers().isNotEmpty && mounted) {
            setState(() {
              _servers = value.loadServers();
            });
          } else {
            loadData();
          }
        });
      } else {
        loadData();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    for (var element in _refreshControllers) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              title: const Text('server_list').tr(),
              floating: true,
              pinned: true,
              forceElevated: innerBoxIsScrolled,
              bottom: PreferredSize(preferredSize: const Size.fromHeight(70), child: _serversTab()),
            ),
          ],
          body: ExtendedTabBarView(
            children: List.generate(2, (index) {
              var data = _servers.where((e) => e.status == index).toList();
              return SmartRefresher(
                onRefresh: loadData,
                controller: _refreshControllers[index],
                child: ListView(
                  addAutomaticKeepAlives: true,
                  padding: EdgeInsets.zero,
                  children: List.generate(data.length, (index) => ServerItem(data[index])),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _serversTab() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: Colors.grey.withOpacity(.3), borderRadius: BorderRadius.circular(20)),
      child: TabBar(
        splashBorderRadius: BorderRadius.circular(20),
        indicatorColor: Colors.white,
        indicator: BoxDecoration(color: Colors.grey.shade100.withOpacity(.4), borderRadius: BorderRadius.circular(20)),
        tabs: [Tab(text: 'standard_servers'.tr()), Tab(text: 'premium_servers'.tr())],
      ),
    );
  }

  void loadData() async {
    List<VpnConfig> resp = await ServersHttp(context).allServers().then((value) {
      for (var element in _refreshControllers) {
        element.refreshCompleted();
        element.loadComplete();
      }
      if (cacheServerList) {
        Preferences.instance().then((pref) {
          pref.saveServers(value: value);
        });
      }
      return value;
    }).catchError((e) {
      for (var element in _refreshControllers) {
        element.refreshFailed();
      }
      return <VpnConfig>[];
    });
    if (mounted) {
      setState(() {
        _servers = resp;
      });
    }
  }
}
