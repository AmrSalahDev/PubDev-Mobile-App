// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pub_api_client/pub_api_client.dart' as _i479;
import 'package:pub_dev_packages_app/core/di/register_model.dart' as _i972;
import 'package:pub_dev_packages_app/features/home/data/remote/packages_remote_datasource.dart'
    as _i268;
import 'package:pub_dev_packages_app/features/home/data/repos/packages_repo_impl.dart'
    as _i588;
import 'package:pub_dev_packages_app/features/home/domain/repos/packages_repo.dart'
    as _i197;
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_favorites_packages_usecase.dart'
    as _i717;
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_observable_videos_usecase.dart'
    as _i369;
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_package_info_usecase.dart'
    as _i289;
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_package_of_the_week_videos_usecase.dart'
    as _i652;
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_top_dart_packages_usecase.dart'
    as _i151;
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_top_flutter_packages_usecase.dart'
    as _i666;
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_trending_packages_usecase.dart'
    as _i763;
import 'package:pub_dev_packages_app/features/home/domain/usecases/get_widget_of_the_week_usecase.dart'
    as _i706;
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_bloc.dart'
    as _i921;
import 'package:retry/retry.dart' as _i689;
import 'package:talker/talker.dart' as _i993;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i689.RetryOptions>(() => registerModule.retryOptions);
    gh.lazySingleton<_i993.Talker>(() => registerModule.talker);
    gh.lazySingleton<_i479.PubClient>(() => registerModule.pubClient);
    gh.lazySingleton<_i519.Client>(() => registerModule.httpClient);
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i268.PackagesRemoteDataSource>(
      () => _i268.PackagesRemoteDataSourceImpl(
        gh<_i479.PubClient>(),
        gh<_i993.Talker>(),
        gh<_i361.Dio>(),
      ),
    );
    gh.lazySingleton<_i197.PackagesRepo>(
      () => _i588.PackagesRepoImpl(gh<_i268.PackagesRemoteDataSource>()),
    );
    gh.lazySingleton<_i717.GetFavoritesPackagesUsecase>(
      () => _i717.GetFavoritesPackagesUsecase(gh<_i197.PackagesRepo>()),
    );
    gh.lazySingleton<_i289.GetPackageInfoUsecase>(
      () => _i289.GetPackageInfoUsecase(gh<_i197.PackagesRepo>()),
    );
    gh.lazySingleton<_i652.GetPackageOfTheWeekVideosUsecase>(
      () => _i652.GetPackageOfTheWeekVideosUsecase(gh<_i197.PackagesRepo>()),
    );
    gh.lazySingleton<_i151.GetTopDartPackagesUsecase>(
      () => _i151.GetTopDartPackagesUsecase(gh<_i197.PackagesRepo>()),
    );
    gh.lazySingleton<_i666.GetTopFlutterPackagesUsecase>(
      () => _i666.GetTopFlutterPackagesUsecase(gh<_i197.PackagesRepo>()),
    );
    gh.lazySingleton<_i763.GetTrendingPackagesUsecase>(
      () => _i763.GetTrendingPackagesUsecase(gh<_i197.PackagesRepo>()),
    );
    gh.lazySingleton<_i369.GetObservableVideosUsecase>(
      () => _i369.GetObservableVideosUsecase(gh<_i197.PackagesRepo>()),
    );
    gh.lazySingleton<_i706.GetWidgetOfTheWeekVideosUsecase>(
      () => _i706.GetWidgetOfTheWeekVideosUsecase(gh<_i197.PackagesRepo>()),
    );
    gh.factory<_i921.PackagesBloc>(
      () => _i921.PackagesBloc(
        getFavoritesPackagesUsecase: gh<_i717.GetFavoritesPackagesUsecase>(),
        getTrendingPackagesUsecase: gh<_i763.GetTrendingPackagesUsecase>(),
        getTopFlutterPackagesUsecase: gh<_i666.GetTopFlutterPackagesUsecase>(),
        getTopDartPackagesUsecase: gh<_i151.GetTopDartPackagesUsecase>(),
        getPackageInfoUsecase: gh<_i289.GetPackageInfoUsecase>(),
        getPackageOfTheWeekVideosUsecase:
            gh<_i652.GetPackageOfTheWeekVideosUsecase>(),
        getObservableVideosUsecase: gh<_i369.GetObservableVideosUsecase>(),
        getWidgetOfTheWeekVideosUsecase:
            gh<_i706.GetWidgetOfTheWeekVideosUsecase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i972.RegisterModule {}
