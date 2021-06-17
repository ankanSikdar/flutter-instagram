import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/blocs/blocs.dart';
import 'package:instagram_clone/models/models.dart';
import 'package:instagram_clone/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;

  ProfileBloc({
    @required UserRepository userRepository,
    @required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        _authBloc = authBloc,
        super(ProfileState.inital());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileLoadUser) {
      yield* _mapProfileLoadUserToState(event);
    }
  }

  Stream<ProfileState> _mapProfileLoadUserToState(
      ProfileLoadUser event) async* {
    yield state.copyWith(status: ProfileStatus.loading);
    try {
      final user = await _userRepository.getUserWithId(userId: event.userId);
      print(user);
      final isCurrentUser = _authBloc.state.user.uid == event.userId;
      yield state.copyWith(
        user: user,
        status: ProfileStatus.loaded,
        isCurrentUser: isCurrentUser,
      );
    } catch (error) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: Failure(message: 'Unable to load user profile'),
      );
    }
  }
}
