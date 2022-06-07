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
    //bannerAd.load();
  }

  @override
  void dispose() {
    //_bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: SizedBox(
        width: AppConstants.bannerAd.size.width.toDouble(),
        height: AppConstants.bannerAd.size.height.toDouble(),
        child: AdWidget(ad: AppConstants.bannerAd),
      ),
    );
  }
}
