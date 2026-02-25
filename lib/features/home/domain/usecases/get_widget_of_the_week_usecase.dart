import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/features/home/domain/repos/packages_repo.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

@lazySingleton
class GetWidgetOfTheWeekVideosUsecase {
  final PackagesRepo repo;

  GetWidgetOfTheWeekVideosUsecase(this.repo);

  Future<List<Video>> call() async {
    return await repo.getWidgetOfTheWeekVideos();
  }
}