import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/features/package_detail/domain/usecases/get_github_health_usecase.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/bloc/github_health/github_health_event.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/bloc/github_health/github_health_state.dart';

@injectable
class GithubHealthBloc extends Bloc<GithubHealthEvent, GithubHealthState> {
  final GetGithubHealthUsecase _getGithubHealthUsecase;

  GithubHealthBloc(this._getGithubHealthUsecase)
    : super(GithubHealthInitial()) {
    on<GetGithubHealthEvent>((event, emit) async {
      emit(GithubHealthLoading());
      try {
        final result = await _getGithubHealthUsecase(event.repoUrl);
        emit(GithubHealthLoaded(result));
      } catch (e) {
        emit(GithubHealthError(e.toString()));
      }
    });
  }
}
