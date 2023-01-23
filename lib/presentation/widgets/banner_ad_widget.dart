import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class BannerAdWidget extends StatefulWidget {
  final BannerAd bannerAd;
  const BannerAdWidget({
    Key? key,
    required this.bannerAd,
  }) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: AdSize.banner.height.toDouble(),
      child: AdWidget(ad: widget.bannerAd),
    );
  }
}
