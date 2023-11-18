import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OAuthWebView extends StatefulWidget {
  final String launchURI; 
  

  const OAuthWebView({
    super.key,
    required this.launchURI,
  });

  @override
  State<OAuthWebView> createState() => _OAuthWebViewState();
}

class _OAuthWebViewState extends State<OAuthWebView> {
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {
            // TODO: Do some error handling
            debugPrint("===============================> onWebResourceError:");
            debugPrint(error.errorType.toString());
            debugPrint(error.errorCode.toString());
            debugPrint(error.description);
          },
          onUrlChange: (change) {
            debugPrint(change.url.toString());
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.launchURI));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OAuth2"),
        actions: [
          IconButton(
            onPressed: () {
              controller.reload();
            },
            icon: const Icon(Icons.refresh),
          ),
          // close button
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}