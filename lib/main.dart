import 'dart:io';

import 'data/datasources/local/database.dart';
import 'presentation/cubit/locale/app_locale_cubit.dart';
import 'presentation/cubit/locale/app_locale_state.dart';
import 'presentation/cubit/randomcategoryexcuse/random_category_excuse_cubit.dart';
import 'presentation/cubit/randomexcuse/random_excuse_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'constants/app_constants.dart';
import 'domain/usecases/get_random_excuse.dart';
import 'domain/usecases/get_random_excuse_by_category.dart';
import 'presentation/router.dart';
import 'presentation/screens/home_screen.dart';
import 'util/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['assets/fonts'], license);
  });
  await dotenv.load(fileName: '.env');
  await AppConstants.bannerAd.load();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              locator<AppLocaleCubit>()..getLanguage(),
        ),
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
      child: BlocBuilder<AppLocaleCubit, AppLocaleState>(
        builder: (context, state) {
          if (state is AppLocaleChanged) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Excuser',
              onGenerateRoute: MyRouter.generateRoute,
              locale: state.language,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              theme: ThemeData(
                fontFamily: 'Montserrat',
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  brightness: Brightness.light,
                  primary: const Color(0xFF8403F8),
                  secondary: const Color(0xFFE106FF),
                ),
                bottomSheetTheme: const BottomSheetThemeData(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
              home: const HomeScreen(),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
