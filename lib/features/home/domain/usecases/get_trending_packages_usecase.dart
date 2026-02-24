import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/home/domain/repos/packages_repo.dart';

@lazySingleton
class GetTrendingPackagesUsecase {
  final PackagesRepo _repo;
  GetTrendingPackagesUsecase(this._repo);

  Future<List<PackageEntity>> call({required int page}) async {
    return await _repo.getTrendingPackages(page: page);
  }
}