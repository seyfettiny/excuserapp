import 'dart:io';
import 'dart:ui';

import '../../../data/datasources/local/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_locale_state.dart';

class AppLocaleCubit extends Cubit<AppLocaleState> {
  Locale get language => state.locale;
  final ExcuseDatabase database;
  AppLocaleCubit(this.database)
      : super(AppLocaleInitial(Locale(Platform.localeName))) {
    getLanguage();
  }

  void getLanguage() {
    database.getLocale().then((value) {
      emit(AppLocaleChanged(Locale(value)));
      return null;
    });    
  }

  void changeLanguage(Locale language) {
    database.setLocale(language.languageCode).then((value) {
      emit(AppLocaleChanged(language));
      return null;
    });
  }
}
