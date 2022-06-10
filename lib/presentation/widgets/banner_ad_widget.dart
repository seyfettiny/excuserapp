import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../constants/app_constants.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: AppConstants.bannerAd.size.height.toDouble(),
      child: AdWidget(ad: AppConstants.bannerAd),
    );
  }
}
