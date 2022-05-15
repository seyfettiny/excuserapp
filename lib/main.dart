import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'locator.dart';
import 'features/excuse/presentation/router.dart';
import 'features/excuse/presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['assets/fonts'], license);
  });
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ExcuserApp',
      onGenerateRoute: MyRouter.generateRoute,
      theme: ThemeData(
          fontFamily: 'Montserrat',
          colorScheme: ColorScheme.fromSwatch().copyWith(
              brightness: Brightness.light,
              primary: const Color(0xFF8403F8),
              secondary: const Color(0xFFE106FF))),
      home: const HomeScreen(),
    );
  }
}
