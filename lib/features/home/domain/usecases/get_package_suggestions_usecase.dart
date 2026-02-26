import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/features/home/domain/repos/packages_repo.dart';

@lazySingleton
class GetPackageSuggestionsUseCase {
  final PackagesRepo _repo;
  GetPackageSuggestionsUseCase(this._repo);

  List<String> call() {
    return _repo.getPackageSuggestions();
  }
}
