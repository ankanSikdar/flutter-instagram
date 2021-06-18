import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/screens/profile/profile_screen.dart';
import 'package:instagram_clone/screens/search/cubit/search_cubit.dart';
import 'package:instagram_clone/widgets/centered_text.dart';
import 'package:instagram_clone/widgets/user_profile_image.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Search Users',
              fillColor: Colors.grey[200],
              filled: true,
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  context.read<SearchCubit>().clearSearch();
                  _textEditingController.clear();
                },
              ),
            ),
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                context.read<SearchCubit>().searchUsers(value);
              }
            },
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.error:
                return CenteredText(text: state.failure.message);
              case SearchStatus.loading:
                return Center(child: CircularProgressIndicator());
              case SearchStatus.loaded:
                return state.users.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          final user = state.users[index];
                          return ListTile(
                            leading: UserProfileImage(
                              radius: 20.0,
                              profileImageUrl: user.profileImageUrl,
                            ),
                            title: Text(
                              user.username,
                              style: TextStyle(fontSize: 16.0),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  ProfileScreen.routeName,
                                  arguments:
                                      ProfileScreenArgs(userId: user.id));
                            },
                          );
                        },
                        itemCount: state.users.length,
                      )
                    : CenteredText(text: 'No Users Found');

              default:
                return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
