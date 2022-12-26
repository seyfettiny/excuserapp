import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:excuserapp/constants/app_constants.dart';
import 'package:excuserapp/data/datasources/local/database.dart';
import 'package:excuserapp/presentation/cubit/randomcategoryexcuse/cubit/random_category_excuse_cubit.dart';
import 'package:excuserapp/presentation/cubit/randomexcuse/random_excuse_cubit.dart';
import 'package:excuserapp/presentation/widgets/banner_ad_widget.dart';
import 'package:excuserapp/presentation/widgets/excuse_by_category_widget.dart';
import 'package:excuserapp/presentation/widgets/random_excuse_widget.dart';
import 'package:excuserapp/util/locator.dart';
import 'package:excuserapp/util/random_num.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _randomIndex =
        RandomNum.random(0, AppConstants.gradientBgColorPairs.length);
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
            colors: AppConstants.gradientBgColorPairs[_randomIndex],
          )),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                RepaintBoundary(
                  child: BlocProvider(
                    create: (context) => locator<RandomExcuseCubit>(),
                    child: const RandomExcuseWidget(),
                  ),
                ),
                const SizedBox(height: 40),
                RepaintBoundary(
                  child: BlocProvider(
                    create: (context) => locator<RandomCategoryExcuseCubit>(),
                    child: const ExcuseByCategoryWidget(),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: const BannerAdWidget(),
      ),
    );
  }
}
