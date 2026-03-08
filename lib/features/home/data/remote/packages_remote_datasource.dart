import 'dart:isolate';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_dev_packages_app/core/const/constants.dart';
import 'package:pub_dev_packages_app/features/home/data/models/package_model.dart';
import 'package:pub_dev_packages_app/features/home/data/models/score_model.dart';
import 'package:talker/talker.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

abstract class PackagesRemoteDataSource {
  Future<List<PackageModel>> getFavoritesPackages({required int page});
  Future<List<PackageModel>> getTrendingPackages({required int page});
  Future<List<PackageModel>> getTopFlutterPackages({required int page});
  Future<List<PackageModel>> getTopDartPackages({required int page});
  Future<PackageModel> getPackageInfo(String packageName);
  Future<ScoreModel> getScore(String name);
  Future<List<Video>> getPackageOfTheWeekVideos();
  Future<List<Video>> getObservableVideos();
  Future<List<Video>> getWidgetOfTheWeekVideos();
  Future<List<Video>> searchVideos(String query);
  List<String> getPackageSuggestions();
}

@LazySingleton(as: PackagesRemoteDataSource)
class PackagesRemoteDataSourceImpl implements PackagesRemoteDataSource {
  final PubClient _client;
  final Talker _talker;
  final Dio _dio;

  PackagesRemoteDataSourceImpl(this._client, this._talker, this._dio);

  List<String> _packageSuggestions = [];

  @override
  Future<List<PackageModel>> getFavoritesPackages({required int page}) async {
    try {
      // Pick a random page between 1 and 5 to get different packages
      int randomPage = Random().nextInt(5) + 1;

      final results = await _client.search(
        'is:flutter-favorite',
        sort: SearchOrder.popularity,
        page: randomPage,
      );

      final packageNames = results.packages.map((p) => p.package).toList();
      _packageSuggestions = packageNames;
      packageNames.shuffle(); // Mix them up!

      return await Future.wait(
        packageNames.map((name) => getPackageInfo(name)).take(8).toList(),
      );
    } catch (e) {
      _talker.error('Error: $e');
      rethrow;
    }
  }

  @override
  List<String> getPackageSuggestions() {
    try {
      _talker.info('Package suggestions: $_packageSuggestions');
      return _packageSuggestions;
    } catch (e) {
      _talker.error('Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<PackageModel>> getTrendingPackages({required int page}) async {
    try {
      final response = await _dio.get(trendingPackages);
      final data = response.data;

      // Get the list of packages from the trending response
      final List<dynamic> packageData = data['packages'] ?? [];

      // Extract the package names
      final packageNames = packageData
          .map((e) => e['name'] as String) // Get the name string
          .take(6) // Take only the first 6
          .toList();

      // Call getPackageInfo for each name to get FULL data (including tags)
      // Future.wait runs these requests in parallel for speed
      return await Future.wait(
        packageNames.map((name) => getPackageInfo(name)).toList(),
      );
    } catch (e) {
      _talker.error('Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<PackageModel>> getTopFlutterPackages({required int page}) async {
    try {
      int randomPage = Random().nextInt(5) + 1;

      final results = await _client.search(
        'sdk:flutter',
        sort: SearchOrder.popularity,
        page: randomPage,
      );
      final packageNames = results.packages.map((p) => p.package).toList();
      packageNames.shuffle(); // Mix them up!

      return await Future.wait(
        packageNames.map((p) => getPackageInfo(p)).take(6).toList(),
      );
    } catch (e) {
      _talker.error('Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<PackageModel>> getTopDartPackages({required int page}) async {
    try {
      int randomPage = Random().nextInt(5) + 1;
      final results = await _client.search(
        'sdk:dart',
        sort: SearchOrder.popularity,
        page: randomPage,
      );
      final packageNames = results.packages.map((p) => p.package).toList();
      packageNames.shuffle(); // Mix them up!

      return await Future.wait(
        packageNames.map((p) => getPackageInfo(p)).take(6).toList(),
      );
    } catch (e) {
      _talker.error('Error: $e');
      rethrow;
    }
  }

  // @override
  // Future<PackageModel> getPackageInfo(String packageName) async {
  //   try {
  //     final response = await _dio.get(
  //       'https://pub.dev/api/packages/$packageName',
  //     );
  //     return PackageModel.fromJson(response.data);
  //   } catch (e) {
  //     _talker.error('Error from getPackageInfo: $e');
  //     rethrow;
  //   }
  // }

  @override
  Future<PackageModel> getPackageInfo(String packageName) async {
    try {
      final responses = await Future.wait([
        _dio.get('https://pub.dev/api/packages/$packageName'),
        _dio.get('https://pub.dev/api/packages/$packageName/score'),
      ]);

      final packageData = responses[0].data as Map<String, dynamic>;
      final scoreData = responses[1].data as Map<String, dynamic>;

      packageData['score'] = scoreData;

      String readmeContent = '';
      String? readmeUrl;

      return PackageModel.fromJson(
        packageData,
        readme: readmeContent,
        readmeUrl: readmeUrl,
      );
    } catch (e) {
      _talker.error('Error in getPackageInfo: $e');
      rethrow;
    }
  }

  @override
  Future<ScoreModel> getScore(String packageName) async {
    try {
      final response = await _dio.get(
        'https://pub.dev/api/packages/$packageName/score',
      );
      return ScoreModel.fromJson(response.data);
    } catch (e) {
      _talker.error('Error from getScore: $e');
      rethrow;
    }
  }

  @override
  Future<List<Video>> getPackageOfTheWeekVideos() async {
    try {
      final videos = await Isolate.run(
        () => _fetchPlaylistVideos(packageOfTheWeekPlaylistUrl),
      );
      _talker.info('Fetched ${videos.length} videos');
      return videos;
    } catch (e) {
      _talker.error('Error fetching playlist: $e');
      rethrow;
    }
  }

  @override
  Future<List<Video>> getObservableVideos() async {
    try {
      final videos = await Isolate.run(
        () => _fetchPlaylistVideos(observablePlaylistUrl),
      );
      _talker.info('Fetched ${videos.length} videos');
      return videos;
    } catch (e) {
      _talker.error('Error fetching playlist: $e');
      rethrow;
    }
  }

  @override
  Future<List<Video>> getWidgetOfTheWeekVideos() async {
    try {
      final videos = await Isolate.run(
        () => _fetchPlaylistVideos(widgetOfTheWeekPlaylistUrl),
      );
      _talker.info('Fetched ${videos.length} videos');
      return videos;
    } catch (e) {
      _talker.error('Error fetching playlist: $e');
      rethrow;
    }
  }

  @override
  Future<List<Video>> searchVideos(String query) async {
    try {
      final videos = await Isolate.run(() => _fetchSearchVideos(query));
      _talker.info('Fetched ${videos.length} videos for search: $query');
      return videos;
    } catch (e) {
      _talker.error('Error searching videos: $e');
      rethrow;
    }
  }
}

Future<List<Video>> _fetchSearchVideos(String query) async {
  final yt = YoutubeExplode();
  try {
    final results = await yt.search.search(query);
    return results.toList();
  } finally {
    yt.close();
  }
}

Future<List<Video>> _fetchPlaylistVideos(String url) async {
  var yt = YoutubeExplode();
  try {
    var playlist = await yt.playlists.get(url);
    List<Video> videoList = await yt.playlists
        .getVideos(playlist.id)
        .take(10)
        .toList();
    videoList.shuffle();
    return videoList;
  } finally {
    yt.close();
  }
}
