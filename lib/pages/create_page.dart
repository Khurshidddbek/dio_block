import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio_block/blocs/create_post_cubit.dart';
import 'package:dio_block/blocs/create_post_state.dart';
import 'package:dio_block/model/post_model.dart';
import 'package:dio_block/views/view_of_create.dart';

class CreatePage extends StatefulWidget {
  static final String id = 'create_page';

  const CreatePage({Key key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  bool isLoading = false;
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _bodyTextEditingController = TextEditingController();

  _finish(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context, 'result');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatePostCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create a new post'),
        ),
        body: BlocBuilder<CreatePostCubit, CreatePostState>(
          builder: (BuildContext context, CreatePostState state) {
            if (state is CreatePostLoading) {
              return viewOfCreate(context, _titleTextEditingController, _bodyTextEditingController, isLoading);
            }
            if (state is CreatePostLoaded) {
              _finish(context);
            }
            if (state is CreatePostError) {
              print('Error : CreatePostError');
            }
            return viewOfCreate(context, _titleTextEditingController, _bodyTextEditingController, isLoading);
          },
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          onPressed: () {
            Post post = Post(title: _titleTextEditingController.text, body: _bodyTextEditingController.text, userId: Random().nextInt(pow(2, 30) - 1));
            CreatePostCubit().apiPostCreate(context, post.title, post.body);
            _finish(context);
          },
          child: Icon(Icons.file_upload),
        ),
      ),
    );
  }
}
