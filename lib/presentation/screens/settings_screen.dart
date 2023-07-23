import 'dart:math';

import '../../constants/app_constants.dart';
import '../../data/datasources/remote/excuser_api.dart';
import '../../domain/usecases/get_random_excuse.dart';
import '../../domain/usecases/get_random_excuse_by_category.dart';
import '../cubit/locale/app_locale_cubit.dart';
import '../cubit/randomcategoryexcuse/random_category_excuse_cubit.dart';
import '../cubit/randomexcuse/random_excuse_cubit.dart';
import '../../util/l10n/l10n.dart';
import '../../util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => RandomExcuseCubit(
            locator<GetRandomExcuseUseCase>(),
          ),
        ),
        BlocProvider(
          create: (_) => RandomCategoryExcuseCubit(
            locator<GetRandomExcuseByCategoryUseCase>(),
          ),
        ),
      ],
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                ListTile(
                  title: Text(context.l10n.changeLanguage),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return Material(
                          child: Scaffold(
                            appBar: AppBar(
                              title: Text(context.l10n.changeLanguage),
                            ),
                            body: Column(children: [
                              ...AppConstants.supportedLocales.entries
                                  .map(
                                    (element) => ListTile(
                                      title: Text(element.key),
                                      onTap: () async {
                                        BlocProvider.of<AppLocaleCubit>(context)
                                            .changeLanguage(element.value);
                                        await BlocProvider.of<RandomExcuseCubit>(context)
                                            .getRandomExcuse();
                                            await BlocProvider.of<RandomCategoryExcuseCubit>(context)
                                            .getRandomExcuseByCategory();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  )
                                  .toList(),
                            ]),
                          ),
                        );
                      },
                    );
                  },
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                ),
                ListTile(
                  title: Text(context.l10n.privacyPolicy),
                  onTap: () {
                    Navigator.pushNamed(context, '/privacyPolicy');
                  },
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}
