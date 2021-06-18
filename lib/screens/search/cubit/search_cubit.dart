import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/models/models.dart';
import 'package:instagram_clone/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final UserRepository _userRepository;

  SearchCubit({@required UserRepository userRepository})
      : this._userRepository = userRepository,
        super(SearchState.inital());

  void searchUsers(String query) async {
    emit(state.copyWith(status: SearchStatus.loading));

    try {
      final users = await _userRepository.searchUsers(query: query);
      emit(state.copyWith(users: users, status: SearchStatus.loaded));
    } catch (error) {
      emit(
        state.copyWith(
          status: SearchStatus.error,
          failure: Failure(message: 'Something went wrong. Please try again.'),
        ),
      );
    }
  }

  void clearSearch() {
    emit(state.copyWith(users: [], status: SearchStatus.initial));
  }
}
