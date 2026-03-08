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
    assert(_current != null,
        'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.');
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
    assert(instance != null,
        'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?');
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
    return Intl.message(
      'View all',
      name: 'viewAll',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      ' and ',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// ` apps.`
  String get apps {
    return Intl.message(
      ' apps.',
      name: 'apps',
      desc: '',
      args: [],
    );
  }

  /// `Flutter`
  String get flutter {
    return Intl.message(
      'Flutter',
      name: 'flutter',
      desc: '',
      args: [],
    );
  }

  /// `Dart`
  String get dart {
    return Intl.message(
      'Dart',
      name: 'dart',
      desc: '',
      args: [],
    );
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

  /// `LIKES`
  String get likes {
    return Intl.message(
      'LIKES',
      name: 'likes',
      desc: '',
      args: [],
    );
  }

  /// `POINTS`
  String get points {
    return Intl.message(
      'POINTS',
      name: 'points',
      desc: '',
      args: [],
    );
  }

  /// `DOWNLOADS`
  String get downloads {
    return Intl.message(
      'DOWNLOADS',
      name: 'downloads',
      desc: '',
      args: [],
    );
  }

  /// `DEFAULT`
  String get defaultt {
    return Intl.message(
      'DEFAULT',
      name: 'defaultt',
      desc: '',
      args: [],
    );
  }

  /// `POPULARITY`
  String get popularity {
    return Intl.message(
      'POPULARITY',
      name: 'popularity',
      desc: '',
      args: [],
    );
  }

  /// `UPDATED`
  String get updated {
    return Intl.message(
      'UPDATED',
      name: 'updated',
      desc: '',
      args: [],
    );
  }

  /// `CREATED`
  String get created {
    return Intl.message(
      'CREATED',
      name: 'created',
      desc: '',
      args: [],
    );
  }

  /// `NEWEST PACKAGE`
  String get newestPackage {
    return Intl.message(
      'NEWEST PACKAGE',
      name: 'newestPackage',
      desc: '',
      args: [],
    );
  }

  /// `RESULTS`
  String get results {
    return Intl.message(
      'RESULTS',
      name: 'results',
      desc: '',
      args: [],
    );
  }

  /// `packages`
  String get packages {
    return Intl.message(
      'packages',
      name: 'packages',
      desc: '',
      args: [],
    );
  }

  /// `Search for "firebase_auth"`
  String get searchForFirebaseAuth {
    return Intl.message(
      'Search for "firebase_auth"',
      name: 'searchForFirebaseAuth',
      desc: '',
      args: [],
    );
  }

  /// `Search for "flutter_svg"`
  String get searchForFlutterSvg {
    return Intl.message(
      'Search for "flutter_svg"',
      name: 'searchForFlutterSvg',
      desc: '',
      args: [],
    );
  }

  /// `Search for "http"`
  String get searchForHttp {
    return Intl.message(
      'Search for "http"',
      name: 'searchForHttp',
      desc: '',
      args: [],
    );
  }

  /// `Search for "provider"`
  String get searchForProvider {
    return Intl.message(
      'Search for "provider"',
      name: 'searchForProvider',
      desc: '',
      args: [],
    );
  }

  /// `Search for "get_it"`
  String get searchForGetIt {
    return Intl.message(
      'Search for "get_it"',
      name: 'searchForGetIt',
      desc: '',
      args: [],
    );
  }

  /// `Search for "dio"`
  String get searchForDio {
    return Intl.message(
      'Search for "dio"',
      name: 'searchForDio',
      desc: '',
      args: [],
    );
  }

  /// `Search for "shared_preferences"`
  String get searchForSharedPreferences {
    return Intl.message(
      'Search for "shared_preferences"',
      name: 'searchForSharedPreferences',
      desc: '',
      args: [],
    );
  }

  /// `Search for "url_launcher"`
  String get searchForUrlLauncher {
    return Intl.message(
      'Search for "url_launcher"',
      name: 'searchForUrlLauncher',
      desc: '',
      args: [],
    );
  }

  /// `Search for "path_provider"`
  String get searchForPathProvider {
    return Intl.message(
      'Search for "path_provider"',
      name: 'searchForPathProvider',
      desc: '',
      args: [],
    );
  }

  /// `Search for "image_picker"`
  String get searchForImagePicker {
    return Intl.message(
      'Search for "image_picker"',
      name: 'searchForImagePicker',
      desc: '',
      args: [],
    );
  }

  /// `SORT BY `
  String get sortBy {
    return Intl.message(
      'SORT BY ',
      name: 'sortBy',
      desc: '',
      args: [],
    );
  }

  /// `default ranking`
  String get sortDefaultRanking {
    return Intl.message(
      'default ranking',
      name: 'sortDefaultRanking',
      desc: '',
      args: [],
    );
  }

  /// `overall score`
  String get sortOverallScore {
    return Intl.message(
      'overall score',
      name: 'sortOverallScore',
      desc: '',
      args: [],
    );
  }

  /// `recently updated`
  String get sortRecentlyUpdated {
    return Intl.message(
      'recently updated',
      name: 'sortRecentlyUpdated',
      desc: '',
      args: [],
    );
  }

  /// `newest package`
  String get sortNewestPackage {
    return Intl.message(
      'newest package',
      name: 'sortNewestPackage',
      desc: '',
      args: [],
    );
  }

  /// `most likes`
  String get sortMostLikes {
    return Intl.message(
      'most likes',
      name: 'sortMostLikes',
      desc: '',
      args: [],
    );
  }

  /// `most pub points`
  String get sortMostPubPoints {
    return Intl.message(
      'most pub points',
      name: 'sortMostPubPoints',
      desc: '',
      args: [],
    );
  }

  /// `downloads`
  String get sortDownloads {
    return Intl.message(
      'downloads',
      name: 'sortDownloads',
      desc: '',
      args: [],
    );
  }

  /// `trending`
  String get sortTrending {
    return Intl.message(
      'trending',
      name: 'sortTrending',
      desc: '',
      args: [],
    );
  }

  /// `Search for`
  String get searchFor {
    return Intl.message(
      'Search for',
      name: 'searchFor',
      desc: '',
      args: [],
    );
  }

  /// `Enable Background Processing`
  String get autoStartTitle {
    return Intl.message(
      'Enable Background Processing',
      name: 'autoStartTitle',
      desc: '',
      args: [],
    );
  }

  /// `To ensure you receive timely notifications for new packages, please disable battery optimizations and enable auto-start if prompted.`
  String get autoStartBody {
    return Intl.message(
      'To ensure you receive timely notifications for new packages, please disable battery optimizations and enable auto-start if prompted.',
      name: 'autoStartBody',
      desc: '',
      args: [],
    );
  }

  /// `Your device has additional battery optimizations. Please follow the steps to disable them.`
  String get manBatteryTitle {
    return Intl.message(
      'Your device has additional battery optimizations. Please follow the steps to disable them.',
      name: 'manBatteryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Follow the steps and disable the optimizations to allow smooth functioning of background tasks.`
  String get manBatteryBody {
    return Intl.message(
      'Follow the steps and disable the optimizations to allow smooth functioning of background tasks.',
      name: 'manBatteryBody',
      desc: '',
      args: [],
    );
  }

  /// `Published`
  String get published {
    return Intl.message(
      'Published',
      name: 'published',
      desc: '',
      args: [],
    );
  }

  /// `Copied!`
  String get copied {
    return Intl.message(
      'Copied!',
      name: 'copied',
      desc: '',
      args: [],
    );
  }

  /// `Tutorials & Guides`
  String get tutorialsAndGuides {
    return Intl.message(
      'Tutorials & Guides',
      name: 'tutorialsAndGuides',
      desc: '',
      args: [],
    );
  }

  /// `No tutorials found for this package`
  String get noTutorialsFound {
    return Intl.message(
      'No tutorials found for this package',
      name: 'noTutorialsFound',
      desc: '',
      args: [],
    );
  }

  /// `{count} VIDEOS`
  String videosCount(Object count) {
    return Intl.message(
      '$count VIDEOS',
      name: 'videosCount',
      desc: '',
      args: [count],
    );
  }

  /// `Weekly Downloads`
  String get weeklyDownloads {
    return Intl.message(
      'Weekly Downloads',
      name: 'weeklyDownloads',
      desc: '',
      args: [],
    );
  }

  /// `Could not find sparkline data`
  String get errorSparklineData {
    return Intl.message(
      'Could not find sparkline data',
      name: 'errorSparklineData',
      desc: '',
      args: [],
    );
  }

  /// `No README found`
  String get noReadmeFound {
    return Intl.message(
      'No README found',
      name: 'noReadmeFound',
      desc: '',
      args: [],
    );
  }

  /// `This package hasn't provided a README file yet.`
  String get noReadmeProvided {
    return Intl.message(
      'This package hasn\'t provided a README file yet.',
      name: 'noReadmeProvided',
      desc: '',
      args: [],
    );
  }

  /// `Visit Repository`
  String get visitRepository {
    return Intl.message(
      'Visit Repository',
      name: 'visitRepository',
      desc: '',
      args: [],
    );
  }

  /// `Readme`
  String get readme {
    return Intl.message(
      'Readme',
      name: 'readme',
      desc: '',
      args: [],
    );
  }

  /// `Changelog`
  String get changelog {
    return Intl.message(
      'Changelog',
      name: 'changelog',
      desc: '',
      args: [],
    );
  }

  /// `Example`
  String get example {
    return Intl.message(
      'Example',
      name: 'example',
      desc: '',
      args: [],
    );
  }

  /// `Videos`
  String get videos {
    return Intl.message(
      'Videos',
      name: 'videos',
      desc: '',
      args: [],
    );
  }

  /// `Installing`
  String get installing {
    return Intl.message(
      'Installing',
      name: 'installing',
      desc: '',
      args: [],
    );
  }

  /// `Versions`
  String get versions {
    return Intl.message(
      'Versions',
      name: 'versions',
      desc: '',
      args: [],
    );
  }

  /// `Scores`
  String get scores {
    return Intl.message(
      'Scores',
      name: 'scores',
      desc: '',
      args: [],
    );
  }

  /// `Changelog data coming soon`
  String get changelogDataComingSoon {
    return Intl.message(
      'Changelog data coming soon',
      name: 'changelogDataComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Versions data coming soon`
  String get versionsDataComingSoon {
    return Intl.message(
      'Versions data coming soon',
      name: 'versionsDataComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `LATEST`
  String get latest {
    return Intl.message(
      'LATEST',
      name: 'latest',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
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
