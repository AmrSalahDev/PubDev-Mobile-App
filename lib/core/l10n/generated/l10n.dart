// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(
      _current != null,
      'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(
      instance != null,
      'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Search packages`
  String get searchPackages {
    return Intl.message(
      'Search packages',
      name: 'searchPackages',
      desc: '',
      args: [],
    );
  }

  /// `Supported by Google`
  String get supportedByGoogle {
    return Intl.message(
      'Supported by Google',
      name: 'supportedByGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Flutter Favorites`
  String get flutterFavorites {
    return Intl.message(
      'Flutter Favorites',
      name: 'flutterFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Some of the packages that demonstrate the highest levels of quality,\nselected by the Flutter Ecosystem Committee`
  String get flutterFavoritesSubtitle {
    return Intl.message(
      'Some of the packages that demonstrate the highest levels of quality,\nselected by the Flutter Ecosystem Committee',
      name: 'flutterFavoritesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Trending packages`
  String get trendingPackages {
    return Intl.message(
      'Trending packages',
      name: 'trendingPackages',
      desc: '',
      args: [],
    );
  }

  /// `Top trending packages in the last 30 days`
  String get trendingPackagesSubtitle {
    return Intl.message(
      'Top trending packages in the last 30 days',
      name: 'trendingPackagesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Top Flutter packages`
  String get topFlutterPackages {
    return Intl.message(
      'Top Flutter packages',
      name: 'topFlutterPackages',
      desc: '',
      args: [],
    );
  }

  /// `Some of the top packages that extend Flutter with new features`
  String get topFlutterPackagesSubtitle {
    return Intl.message(
      'Some of the top packages that extend Flutter with new features',
      name: 'topFlutterPackagesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Top Dart packages`
  String get topDartPackages {
    return Intl.message(
      'Top Dart packages',
      name: 'topDartPackages',
      desc: '',
      args: [],
    );
  }

  /// `Some of the top packages for any Dart-based app or program`
  String get topDartPackagesSubtitle {
    return Intl.message(
      'Some of the top packages for any Dart-based app or program',
      name: 'topDartPackagesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `View all`
  String get viewAll {
    return Intl.message('View all', name: 'viewAll', desc: '', args: []);
  }

  /// `The official package repository for `
  String get officialPackageRepository {
    return Intl.message(
      'The official package repository for ',
      name: 'officialPackageRepository',
      desc: '',
      args: [],
    );
  }

  /// ` and `
  String get and {
    return Intl.message(' and ', name: 'and', desc: '', args: []);
  }

  /// ` apps.`
  String get apps {
    return Intl.message(' apps.', name: 'apps', desc: '', args: []);
  }

  /// `Flutter`
  String get flutter {
    return Intl.message('Flutter', name: 'flutter', desc: '', args: []);
  }

  /// `Dart`
  String get dart {
    return Intl.message('Dart', name: 'dart', desc: '', args: []);
  }

  /// `Package of the week`
  String get packageOfTheWeek {
    return Intl.message(
      'Package of the week',
      name: 'packageOfTheWeek',
      desc: '',
      args: [],
    );
  }

  /// `Package of the week is a series of quick, animated videos, each of which covers a particular package`
  String get packageOfTheWeekSubtitle {
    return Intl.message(
      'Package of the week is a series of quick, animated videos, each of which covers a particular package',
      name: 'packageOfTheWeekSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `View Playlist`
  String get viewPlaylist {
    return Intl.message(
      'View Playlist',
      name: 'viewPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Observable Flutter`
  String get observableFlutter {
    return Intl.message(
      'Observable Flutter',
      name: 'observableFlutter',
      desc: '',
      args: [],
    );
  }

  /// `Observable Flutter is a series of quick, animated videos, each of which covers a particular package`
  String get observableFlutterSubtitle {
    return Intl.message(
      'Observable Flutter is a series of quick, animated videos, each of which covers a particular package',
      name: 'observableFlutterSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Widget of the week`
  String get widgetOfTheWeek {
    return Intl.message(
      'Widget of the week',
      name: 'widgetOfTheWeek',
      desc: '',
      args: [],
    );
  }

  /// `Widget of the week is a series of quick, animated videos, each of which covers a particular widget`
  String get widgetOfTheWeekSubtitle {
    return Intl.message(
      'Widget of the week is a series of quick, animated videos, each of which covers a particular widget',
      name: 'widgetOfTheWeekSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Could not launch video`
  String get couldNotLaunchVideo {
    return Intl.message(
      'Could not launch video',
      name: 'couldNotLaunchVideo',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
