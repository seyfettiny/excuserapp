import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_constants.dart';
import '../../data/datasources/local/database.dart';
import '../cubit/randomcategoryexcuse/random_category_excuse_cubit.dart';
import '../cubit/randomexcuse/random_excuse_cubit.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/excuse_by_category_widget.dart';
import '../widgets/random_excuse_widget.dart';
import '../../util/locator.dart';
import '../../util/random_num.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var randomIndex =
        RandomNum.random(0, AppConstants.gradientBgColors.length);
    return Center(
      child: Scaffold(
        backgroundColor: Colors.green,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.black.withAlpha(20),
          title: const Text(
            'Excuser',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
                icon: const Icon(Icons.settings)),
            Visibility(
              visible: kDebugMode,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/dbViewer',
                      arguments: locator<ExcuseDatabase>.call());
                },
                icon: const Icon(Icons.storage_rounded),
              ),
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: AppConstants.gradientBgColors[randomIndex],
          )),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: const [
                RepaintBoundary(
                  child: RandomExcuseWidget(),
                ),
                SizedBox(height: 40),
                RepaintBoundary(
                  child: ExcuseByCategoryWidget(),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: BannerAdWidget(bannerAd: AppConstants.bannerAd),
      ),
    );
  }
}
