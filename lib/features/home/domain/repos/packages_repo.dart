import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/score_entity.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

abstract class PackagesRepo {
  Future<List<PackageEntity>> getFavoritesPackages({int page});
  Future<List<PackageEntity>> getTrendingPackages({int page});
  Future<List<PackageEntity>> getTopFlutterPackages({int page});
  Future<List<PackageEntity>> getTopDartPackages({int page});
  Future<PackageEntity> getPackageInfo(String packageName);
  Future<ScoreEntity> getScore(String packageName);
  Future<List<Video>> getPackageOfTheWeekVideos();
  Future<List<Video>> getObservableVideos();
  Future<List<Video>> getWidgetOfTheWeekVideos();
}