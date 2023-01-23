import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:excuserapp/presentation/widgets/banner_ad_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/src/ad_instance_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final List<MethodCall> log = <MethodCall>[];

  setUp(() async {
    log.clear();
    instanceManager = AdInstanceManager('plugins.flutter.io/google_mobile_ads');
    instanceManager.channel
        .setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'loadBannerAd':
        case 'disposeAd':
          return Future<void>.value();
        default:
          assert(false);
          return;
      }
    });
  });
  Future<void> sendAdEvent(
      int adId, String eventName, AdInstanceManager instanceManager,
      [Map<String, dynamic>? additionalArgs]) async {
    Map<String, dynamic> args = {
      'adId': adId,
      'eventName': eventName,
    };
    additionalArgs?.entries
        .forEach((element) => args[element.key] = element.value);
    final MethodCall methodCall = MethodCall('onAdEvent', args);
    final ByteData data =
        instanceManager.channel.codec.encodeMethodCall(methodCall);

    return instanceManager.channel.binaryMessenger.handlePlatformMessage(
      'plugins.flutter.io/google_mobile_ads',
      data,
      (ByteData? data) {},
    );
  }

  testWidgets('banner ad widget iOS', (tester) async {
    //TestWidgetsFlutterBinding.ensureInitialized();
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    AdRequest request = AdRequest();

    // Check that listener callbacks are invoked
    Completer<Ad> loaded = Completer<Ad>();
    Completer<List<dynamic>> failedToLoad = Completer<List<dynamic>>();
    Completer<Ad> opened = Completer<Ad>();
    Completer<Ad> clicked = Completer<Ad>();
    Completer<Ad> impression = Completer<Ad>();
    Completer<Ad> closed = Completer<Ad>();
    Completer<Ad> willDismiss = Completer<Ad>();
    Completer<List<dynamic>> paidEvent = Completer<List<dynamic>>();

    BannerAdListener bannerListener = BannerAdListener(
      onAdLoaded: (ad) => loaded.complete(ad),
      onAdFailedToLoad: (ad, error) =>
          failedToLoad.complete(<Object>[ad, error]),
      onAdImpression: (ad) => impression.complete(ad),
      onPaidEvent: (ad, value, precision, currency) =>
          paidEvent.complete(<Object>[ad, value, precision, currency]),
      onAdClicked: (ad) => clicked.complete(ad),
      onAdClosed: (ad) => closed.complete(ad),
      onAdOpened: (ad) => opened.complete(ad),
      onAdWillDismissScreen: (ad) => willDismiss.complete(ad),
    );

    var bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ad-unit',
      listener: bannerListener,
      request: request,
    );
    await bannerAd.load();

    //Simulate load callback
    await sendAdEvent(0, 'onAdLoaded', instanceManager);

    BannerAd createdAd = instanceManager.adFor(0) as BannerAd;
    expect(instanceManager.adFor(0), isNotNull);
    expect(bannerAd, createdAd);
    expect(await loaded.future, bannerAd);

    await sendAdEvent(0, 'onBannerImpression', instanceManager);
    expect(await impression.future, bannerAd);

    await sendAdEvent(0, 'adDidRecordClick', instanceManager);
    expect(await clicked.future, bannerAd);

    await sendAdEvent(0, 'onBannerWillPresentScreen', instanceManager);
    expect(await opened.future, bannerAd);

    await sendAdEvent(0, 'onBannerDidDismissScreen', instanceManager);
    expect(await closed.future, bannerAd);

    await sendAdEvent(0, 'onBannerWillDismissScreen', instanceManager);
    expect(await willDismiss.future, bannerAd);

    await tester.pumpWidget(MaterialApp(
        home: BannerAdWidget(
      bannerAd: createdAd,
    )));

    await tester.pumpAndSettle();

    expect(find.byType(BannerAdWidget), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets(
    'banner ad widget android',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      AdRequest request = const AdRequest();

      // Check that listener callbacks are invoked
      Completer<Ad> loaded = Completer<Ad>();
      Completer<List<dynamic>> failedToLoad = Completer<List<dynamic>>();
      Completer<Ad> opened = Completer<Ad>();
      Completer<Ad> clicked = Completer<Ad>();
      Completer<Ad> impression = Completer<Ad>();
      Completer<Ad> closed = Completer<Ad>();
      Completer<List<dynamic>> paidEvent = Completer<List<dynamic>>();

      BannerAdListener bannerListener = BannerAdListener(
        onAdLoaded: (ad) => loaded.complete(ad),
        onAdFailedToLoad: (ad, error) =>
            failedToLoad.complete(<Object>[ad, error]),
        onAdImpression: (ad) => impression.complete(ad),
        onPaidEvent: (ad, value, precision, currency) =>
            paidEvent.complete(<Object>[ad, value, precision, currency]),
        onAdClicked: (ad) => clicked.complete(ad),
        onAdClosed: (ad) => closed.complete(ad),
        onAdOpened: (ad) => opened.complete(ad),
      );

      var bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ad-unit',
        listener: bannerListener,
        request: request,
      );
      await bannerAd.load();

      // Simulate load callback
      await sendAdEvent(0, 'onAdLoaded', instanceManager);

      BannerAd createdAd = instanceManager.adFor(0) as BannerAd;
      expect(instanceManager.adFor(0), isNotNull);
      expect(bannerAd, createdAd);
      expect(await loaded.future, bannerAd);

      await sendAdEvent(0, 'onAdImpression', instanceManager);
      expect(await impression.future, bannerAd);

      await sendAdEvent(0, 'onAdClicked', instanceManager);
      expect(await clicked.future, bannerAd);

      await sendAdEvent(0, 'onAdOpened', instanceManager);
      expect(await opened.future, bannerAd);

      await sendAdEvent(0, 'onAdClosed', instanceManager);
      expect(await closed.future, bannerAd);

      await sendAdEvent(0, 'onAdClicked', instanceManager);
      expect(await clicked.future, bannerAd);

      await tester.pump(Duration(seconds: 1));

      await tester.pumpWidget(
        MaterialApp(
          home: BannerAdWidget(
            bannerAd: createdAd,
          ),
        ),
        const Duration(seconds: 1),
        EnginePhase.build,
      );

      expect(find.byType(BannerAdWidget), findsOneWidget);
      debugDefaultTargetPlatformOverride = null;
    },
  );
}
