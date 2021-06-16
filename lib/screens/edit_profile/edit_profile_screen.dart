import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/repositories/repositories.dart';
import 'package:instagram_clone/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:instagram_clone/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram_clone/widgets/widgets.dart';

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
        child: EditProfile(user: args.context.read<ProfileBloc>().state.user),
      ),
    );
  }

  final User user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EditProfile({Key key, @required this.user}) : super(key: key);

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<EditProfileCubit>().submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state.status == EditProfileStatus.success) {
              Navigator.of(context).pop();
            } else if (state.status == EditProfileStatus.error) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  content: state.failure.message,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (state.status == EditProfileStatus.submitting)
                    LinearProgressIndicator(),
                  SizedBox(height: 32.0),
                  GestureDetector(
                    onTap: () {},
                    child: UserProfileImage(
                      radius: 80.0,
                      profileImageUrl: user.profileImageUrl,
                      profileImage: state.profileImage,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: user.username,
                            decoration: InputDecoration(hintText: 'Username'),
                            onChanged: (value) => context
                                .read<EditProfileCubit>()
                                .usernameChanged(value),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Username cannot be empty';
                              } else if (value.contains(' ')) {
                                return 'Username cannot contain whitespace';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: user.bio,
                            decoration: InputDecoration(hintText: 'Bio'),
                            onChanged: (value) => context
                                .read<EditProfileCubit>()
                                .bioChanged(value),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Bio cannot be empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 28.0),
                          ElevatedButton(
                            onPressed: () {
                              _submitForm(
                                context,
                                state.status == EditProfileStatus.submitting,
                              );
                            },
                            child: Text('Update'),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
