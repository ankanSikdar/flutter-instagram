import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/repositories/repositories.dart';
import 'package:instagram_clone/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:instagram_clone/screens/profile/bloc/profile_bloc.dart';

class EditProfileScreenArgs {
  final BuildContext context;

  EditProfileScreenArgs({@required this.context});
}

class EditProfile extends StatelessWidget {
  static const String routeName = '/edit-profile';

  static Route route({@required EditProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider<EditProfileCubit>(
        create: (_) => EditProfileCubit(
          userRepository: context.read<UserRepository>(),
          storageRepository: context.read<StorageRepository>(),
          profileBloc: args.context.read<ProfileBloc>(),
        ),
        child: EditProfile(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
    );
  }
}
