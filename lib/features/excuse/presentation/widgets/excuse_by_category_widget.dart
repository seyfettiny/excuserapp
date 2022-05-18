import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../cubit/randomcategoryexcuse/cubit/random_category_excuse_cubit.dart';
import 'loading_widget.dart';

class ExcuseByCategoryWidget extends StatefulWidget {
  const ExcuseByCategoryWidget({Key? key}) : super(key: key);

  @override
  State<ExcuseByCategoryWidget> createState() => _ExcuseByCategoryWidgetState();
}

class _ExcuseByCategoryWidgetState extends State<ExcuseByCategoryWidget> {
  var _excuseCategory = 'family';
  var _excuse = '';
  var _adCounter = 0;
  //late InterstitialAd _interstitialAd;

  @override
  void initState() {
    super.initState();
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
  //             //_interstitialAd.dispose();
  //             _adCounter = 0;
  //           },
  //           onAdFailedToShowFullScreenContent: (ad, error) {
  //             //_interstitialAd.dispose();
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
        width: MediaQuery.of(context).size.width * 0.9,
        borderRadius: BorderRadius.circular(24),
        height: 240,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Center(
                child: BlocBuilder<RandomCategoryExcuseCubit,
                    RandomCategoryExcuseState>(
                  builder: (context, state) {
                    if (state is RandomCategoryExcuseInitial) {
                      context
                          .read<RandomCategoryExcuseCubit>()
                          .getRandomExcuseByCategory(_excuseCategory);
                    }
                    if (state is RandomCategoryExcuseLoading) {
                      return const LoadingWidget();
                    } else if (state is RandomCategoryExcuseError) {
                      return const Center(
                          child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ));
                    } else if (state is RandomCategoryExcuseLoaded) {
                      _excuse = state.excuse.excuse;
                      return Text(
                        state.excuse.excuse,
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
            Wrap(
              runSpacing: -10,
              spacing: 10,
              children: [
                ChoiceChip(
                  label: const Text('family'),
                  selected: _excuseCategory == 'family',
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                      color: _excuseCategory == 'family'
                          ? Colors.white
                          : Colors.black),
                  onSelected: (bool isSelected) {
                    setState(() {
                      _excuseCategory = 'family';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('office'),
                  selected: _excuseCategory == 'office',
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                      color: _excuseCategory == 'office'
                          ? Colors.white
                          : Colors.black),
                  onSelected: (bool isSelected) {
                    setState(() {
                      _excuseCategory = 'office';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('children'),
                  selected: _excuseCategory == 'children',
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                      color: _excuseCategory == 'children'
                          ? Colors.white
                          : Colors.black),
                  onSelected: (bool isSelected) {
                    setState(() {
                      _excuseCategory = 'children';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('college'),
                  selected: _excuseCategory == 'college',
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                      color: _excuseCategory == 'college'
                          ? Colors.white
                          : Colors.black),
                  onSelected: (bool isSelected) {
                    setState(() {
                      _excuseCategory = 'college';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('party'),
                  selected: _excuseCategory == 'party',
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                      color: _excuseCategory == 'party'
                          ? Colors.white
                          : Colors.black),
                  onSelected: (bool isSelected) {
                    setState(() {
                      _excuseCategory = 'party';
                    });
                  },
                ),
              ],
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
                      context
                          .read<RandomCategoryExcuseCubit>()
                          .getRandomExcuseByCategory(_excuseCategory);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Text(
                      'Get another one',
                      style: TextStyle(color: Colors.white),
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
