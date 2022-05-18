import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyWidget extends StatefulWidget {
  PrivacyPolicyWidget({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyWidget> createState() => _PrivacyPolicyWidgetState();
}

class _PrivacyPolicyWidgetState extends State<PrivacyPolicyWidget> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const WebView(
        initialUrl:
            'https://www.privacypolicygenerator.info/live.php?token=c8b3d8k0Ku1voR6G0HCr6WpwW8wrPb07',
      ),
    );
  }
}
