import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:instagram_clone/helpers/helpers.dart';
import 'package:instagram_clone/screens/create_post/cubit/create_post_cubit.dart';
import 'package:instagram_clone/widgets/widgets.dart';

class CreatePostScreen extends StatelessWidget {
  static const String routeName = '/create-post';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm({
    @required BuildContext context,
    @required File postImage,
    @required bool isSubmitting,
  }) {
    if (_formKey.currentState.validate() &&
        postImage != null &&
        !isSubmitting) {
      context.read<CreatePostCubit>().submit();
    }
  }

  void _selectPostImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.rectangle,
      title: 'Create Post',
    );
    if (pickedFile != null) {
      context.read<CreatePostCubit>().postImageChanged(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Post'),
        ),
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) {
            if (state.status == CreatePostStatus.success) {
              _formKey.currentState.reset();
              context.read<CreatePostCubit>().reset();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Post Created Successfully'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1),
                ),
              );
            } else if (state.status == CreatePostStatus.error) {
              showDialog(
                context: context,
                builder: (_) => ErrorDialog(
                  content: state.failure.message,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _selectPostImage(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: state.postImage == null
                          ? Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 120.0,
                            )
                          : Image.file(state.postImage),
                    ),
                  ),
                  if (state.status == CreatePostStatus.submitting)
                    LinearProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(hintText: 'Caption'),
                            onChanged: (value) => context
                                .read<CreatePostCubit>()
                                .captionChanged(value),
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Caption cannot be empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 28.0,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _submitForm(
                                  context: context,
                                  postImage: state.postImage,
                                  isSubmitting: state.status ==
                                      CreatePostStatus.submitting);
                            },
                            child: Text('Post'),
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
