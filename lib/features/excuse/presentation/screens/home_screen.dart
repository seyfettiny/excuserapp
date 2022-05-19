import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/app_constants.dart';
import '../../../../locator.dart';
import '../../data/datasources/local/database.dart';
import '../cubit/randomcategoryexcuse/cubit/random_category_excuse_cubit.dart';
import '../cubit/randomexcuse/random_excuse_cubit.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/excuse_by_category_widget.dart';
import '../widgets/random_excuse_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _randomIndex = Random().nextInt(AppConstants.backgrounds.length);
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
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
                icon: const Icon(Icons.settings)),
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
              image: AssetImage(AppConstants.backgrounds[_randomIndex]),
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
        bottomSheet: BannerAdWidget(),
      ),
    );
  }
}
