import 'dart:io';
import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class AppLocaleState extends Equatable {
  final Locale locale;
  const AppLocaleState(this.locale);

  @override
  List<Object> get props => [locale];
}

class AppLocaleInitial extends AppLocaleState {
  const AppLocaleInitial(super.language);

  Locale get language => Locale(Platform.localeName.split('_')[0]);

  @override
  List<Object> get props => [language];
}

class AppLocaleChanged extends AppLocaleState {
  final Locale language;

  const AppLocaleChanged(this.language) : super(language);

  @override
  List<Object> get props => [language];
}
