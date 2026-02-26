import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/features/home/data/remote/packages_remote_datasource.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/score_entity.dart';
import 'package:pub_dev_packages_app/features/home/domain/repos/packages_repo.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

@LazySingleton(as: PackagesRepo)
class PackagesRepoImpl implements PackagesRepo {
  final PackagesRemoteDataSource _remoteDataSource;
  PackagesRepoImpl(this._remoteDataSource);
  

  @override
  Future<List<PackageEntity>> getFavoritesPackages({page = 1}) async {
    return await _remoteDataSource.getFavoritesPackages(page: page);
  }

  @override
  Future<List<PackageEntity>> getTopDartPackages({page = 1}) async {
    return await _remoteDataSource.getTopDartPackages(page: page);
  }

  @override
  Future<List<PackageEntity>> getTopFlutterPackages({page = 1}) async {
    return await _remoteDataSource.getTopFlutterPackages(page: page);
  }

  @override
  Future<List<PackageEntity>> getTrendingPackages({page = 1}) async {
    return await _remoteDataSource.getTrendingPackages(page: page);
  }

   @override
  Future<PackageEntity> getPackageInfo(String name) async {

    // // PARALLEL API CALLS
    // final results = await Future.wait([
    //   _remoteDataSource.getPackageInfo(name),
    //   _remoteDataSource.getScore(name),
    // ]);

    // final packageModel = results[0] as PackageModel;
    // final scoreModel = results[1] as ScoreModel;

    // return PackageEntity(
    //   name: packageModel.name,
    //   latest: packageModel.latest,
    //   versions: packageModel.versions,
    //   score: scoreModel,
    // );
    return await _remoteDataSource.getPackageInfo(name);  
  }

  @override
  Future<ScoreEntity> getScore(String packageName) async {
    return await _remoteDataSource.getScore(packageName);
  }

  @override
  Future<List<Video>> getPackageOfTheWeekVideos() async {
    return await _remoteDataSource.getPackageOfTheWeekVideos();
  }

  @override
  Future<List<Video>> getObservableVideos() async {
    return await _remoteDataSource.getObservableVideos();
  }

  @override
  Future<List<Video>> getWidgetOfTheWeekVideos() async {
    return await _remoteDataSource.getWidgetOfTheWeekVideos();
  }

  @override
  List<String> getPackageSuggestions() {
    return _remoteDataSource.getPackageSuggestions();
  }
}