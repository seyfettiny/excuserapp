import 'package:excuserapp/presentation/widgets/privacy_policy_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  testWidgets('privacy policy widget test', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrivacyPolicyWidget()));
    await tester.pumpAndSettle();

    final textFinder = find.text('Privacy Policy');
    expect(textFinder, findsOneWidget);

    final webViewFinder = find.byType(WebView);
    expect(webViewFinder, findsOneWidget);

    final webViewUrl =
        (tester.firstWidget(webViewFinder) as WebView).initialUrl;
    expect(webViewUrl, 'https://excuserapp.web.app/privacypolicy.html');

    expect(find.byType(PrivacyPolicyWidget), findsOneWidget);
  });
}
