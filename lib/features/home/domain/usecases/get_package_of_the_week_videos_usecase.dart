import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/features/home/domain/repos/packages_repo.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

@lazySingleton
class GetPackageOfTheWeekVideosUsecase {
  final PackagesRepo _repo;

  GetPackageOfTheWeekVideosUsecase(this._repo);

  Future<List<Video>> call() async {
    return await _repo.getPackageOfTheWeekVideos();
  }
}