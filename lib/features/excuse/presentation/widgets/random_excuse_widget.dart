import 'dart:io';

import 'package:excuserapp/features/excuse/presentation/widgets/loading_widget.dart';
import 'package:glass_kit/glass_kit.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../locator.dart';
import '../../../../util/excuse_translator.dart';
import '../cubit/randomexcuse/random_excuse_cubit.dart';

class RandomExcuseWidget extends StatelessWidget {
  var _excuse = '';
  var _adCounter = 0;
  late final ExcuseTranslator translator;
  //late InterstitialAd _interstitialAd;

  RandomExcuseWidget({Key? key}) : super(key: key) {
    translator = locator<ExcuseTranslator>();
    //_initAd();
  }
  // void _initAd() {
  //   InterstitialAd.load(
  //     adUnitId: Platform.isAndroid
  //         ? 'ca-app-pub-3940256099942544/1033173712'
  //         : 'ca-app-pub-3940256099942544/4411468910',
  //     request: const AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (InterstitialAd ad) {
  //         // Keep a reference to the ad so you can show it later.
  //         _interstitialAd = ad;
  //         _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
  //           onAdDismissedFullScreenContent: (ad) {
  //             _adCounter = 0;
  //           },
  //           onAdFailedToShowFullScreenContent: (ad, error) {
  //             _adCounter = 0;
  //           },
  //         );
  //         _adCounter = 0;
  //       },
  //       onAdFailedToLoad: (LoadAdError error) {
  //         debugPrint('InterstitialAd failed to load: $error');
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: GlassContainer.clearGlass(
        height: 170,
        width: MediaQuery.of(context).size.width * 0.9,
        borderRadius: BorderRadius.circular(24),
        blur: 2,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: BlocBuilder<RandomExcuseCubit, RandomExcuseState>(
                        builder: (context, state) {
                          if (state is RandomExcuseInitial) {
                            context.read<RandomExcuseCubit>().getRandomExcuse();
                          }
                          if (state is RandomExcuseLoading) {
                            return const LoadingWidget();
                          } else if (state is RandomExcuseError) {
                            return const Center(
                                child: Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            ));
                          } else if (state is RandomExcuseLoaded) {
                            _excuse = state.excuse.excuse;
                            debugPrint(state.excuse.category);

                            return Text(
                              _excuse,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Center(
                  child: OutlinedButton(
                    onPressed: () {
                      if (_adCounter >= 6) {
                        //_interstitialAd.show();
                        //_initAd();
                      } else {
                        _adCounter++;
                      }
                      context.read<RandomExcuseCubit>().getRandomExcuse();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: FutureBuilder(
                      future: translator.translateText('Another Excuse'),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Shimmer.fromColors(
                            highlightColor: Colors.grey[300]!,
                            baseColor: Colors.grey[400]!,
                            child: Container(
                              width: 20,
                            ),
                          );
                        }
                        return Text(
                          snapshot.data as String,
                          style: const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: _excuse));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Copied to clipboard'),
                      ));
                      debugPrint(_excuse);
                    },
                    icon: const Icon(Icons.copy),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
