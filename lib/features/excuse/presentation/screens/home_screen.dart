import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:excuserapp/env/env.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../locator.dart';
import '../../data/datasources/local/database.dart';
import '../cubit/randomcategoryexcuse/cubit/random_category_excuse_cubit.dart';
import '../cubit/randomexcuse/random_excuse_cubit.dart';
import '../widgets/excuse_by_category_widget.dart';
import '../widgets/random_excuse_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _backgrounds = [
    'assets/images/2.png',
    'assets/images/5.jpg',
    'assets/images/13.jpg',
    'assets/images/16.jpg',
    'assets/images/21.jpg',
    'assets/images/31.jpg',
    'assets/images/45.jpg',
  ];
  final BannerAd _bannerAd = BannerAd(
    adUnitId: Platform.isAndroid
        ? Env.bannerkey
        : 'ca-app-pub-3940256099942544/2934735716',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );
  @override
  void initState() {
    super.initState();
    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _randomIndex = Random().nextInt(_backgrounds.length);
    return Center(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.black.withAlpha(20),
          title: const Text(
            'ExcuserApp',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            kDebugMode
                ? IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/dbViewer',
                          arguments: locator<ExcuseDatabase>.call());
                    },
                    icon: const Icon(Icons.storage_rounded),
                  )
                : Container()
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_backgrounds[_randomIndex]),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlocProvider(
                    create: (context) => locator<RandomExcuseCubit>(),
                    child: RandomExcuseWidget(),
                  ),
                  const SizedBox(height: 40),
                  BlocProvider(
                    create: (context) => locator<RandomCategoryExcuseCubit>(),
                    child: const ExcuseByCategoryWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: SizedBox(
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd),
          ),
        ),
      ),
    );
  }
}
