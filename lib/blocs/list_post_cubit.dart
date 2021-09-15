import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio_block/blocs/list_post_state.dart';
import 'package:dio_block/model/post_model.dart';
import 'package:dio_block/pages/create_page.dart';
import 'package:dio_block/services/http_service.dart';

class ListPostCubit extends Cubit<ListPostState> {
  ListPostCubit() : super(ListPostInit());

  void apiPostList() async {
    emit(ListPostLoading());

    var response = await Network.GET(Network.BASE + Network.API_LIST); //     print(response);

    if (response != null) {
      emit(ListPostLoaded(posts: Network.parsePostList(response)));
    } else {
      emit(ListPostError(error: "Couldn't fetch posts"));
    }
  }

  void apiPostDelete(Post post) async {
    emit(ListPostLoading());

    var response = await Network.DEL(Network.BASE + Network.API_DELETE + post.id.toString());
    print(response);

    if (response != null) {
      apiPostList();
    } else {
      emit(ListPostError(error: "Couldn't delete post"));
    }
  }

  void callCreatePage(BuildContext context) async {
    var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePage()));
    if (result != null) {
      BlocProvider.of<ListPostCubit>(context).apiPostList();
    }
  }
}