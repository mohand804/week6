import 'package:bloc/bloc.dart';
import 'package:week6/core/networking/api_result.dart';
import 'package:week6/features/home/data/repo/home_repo.dart';
import 'package:week6/features/home/logic/cubit/home_state.dart' show HomeState;

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;
  HomeCubit(this.homeRepo) : super(HomeState.initial());

  Future<void> getPopularMovies({int page = 1}) async {
    emit(HomeState.loding());
    final result = await homeRepo.getPopularMovies(page: page);
    result.when(
      success: (data) {
        emit(HomeState.success(data));
      },
      failure: (error) {
        emit(HomeState.error(error));
      },
    );
  }
}
