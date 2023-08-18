import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../components/adaptive_progress_indicator.dart';

class HtmlScreen extends StatelessWidget {
  final String? asset;
  final String? title;

  const HtmlScreen({Key? key, this.asset, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          FutureBuilder<String>(
            future: rootBundle.loadString(asset!),
            builder: (context, snapshot) => snapshot.hasData
                ? Html(data: snapshot.data ?? "", shrinkWrap: true, onLinkTap: (link, _, __, ___) => launchUrlString(link!))
                : Container(height: 300, alignment: Alignment.center, child: const AdaptiveProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
