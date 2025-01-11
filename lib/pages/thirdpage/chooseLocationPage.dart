import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// class MapImage extends StatefulWidget {
//   const MapImage(this.mapUrl);
//   final mapUrl;

//   @override
//   _MapImageState createState() => _MapImageState();
// }

// class _MapImageState extends State<MapImage> {
//   @override
//   Widget build(BuildContext context) {
//     return WebView(
//       initialUrl: widget.mapUrl,
//       javascriptMode: JavascriptMode.unrestricted,
//       navigationDelegate: (NavigationRequest request) async {
//         if (request.url.startsWith('intent://')) {
//           print('blocking navigation to $request');
//           await urlLauncher(request.url);
//           return NavigationDecision.prevent;
//         }
//         print('allowing navigation to $request');
//         return NavigationDecision.navigate;
//       },
//     );
//   }
// }

class ChooseLocationPage extends StatefulWidget {
  ChooseLocationPage({Key? key}) : super(key: key);

  @override
  _ChooseLocationPageState createState() => _ChooseLocationPageState();
}

Future urlLauncher(String url) async {
// Check if URL contains "intent"
  if (url.contains(RegExp('^intent://.*\$'))) {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      print("urlLauncher $url");
    } else {
      print('Could not launch $url');
    }
  }
  return url;
}

class _ChooseLocationPageState extends State<ChooseLocationPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://flutter-python-623da.web.app/index.html'));
  }

  Future<String> getResolvedLink(String url) async {
    String? link;
    try {
      http.Request request = http.Request('GET', Uri.parse(url));
      request.followRedirects = false;

      http.Client client = http.Client();

      http.StreamedResponse streamedResponse = await client.send(request);

      link = streamedResponse.headers['location'] ?? 'error';
    } catch (e) {
      link = 'error';
    }

    return link;
  }

  /// This method is to use getResolvedLink and getKakaoMapURL easily with latitude, longitude, placeName(optional).
  Future<String> getMapScreenURL(String originalURL) async {
    String resolvedURL = await getResolvedLink(originalURL);
    //String resolvedURL = await urlLauncher(originalURL);
    return resolvedURL;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("출발지 선택"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
