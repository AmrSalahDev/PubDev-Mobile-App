import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/home/domain/repos/packages_repo.dart';

@lazySingleton
class GetPackageInfoUsecase {
  final PackagesRepo _repo;

  GetPackageInfoUsecase(this._repo);

  Future<PackageEntity> call(String packageName) async {
    return await _repo.getPackageInfo(packageName);
  }
}