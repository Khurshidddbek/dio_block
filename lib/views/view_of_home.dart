import 'package:flutter/material.dart';
import 'package:dio_block/model/post_model.dart';

import 'item_of_post.dart';

Widget viewOfHome(List<Post> items, bool isLoading) {
  return Stack(
    children: [
      ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, index) {
          return itemOfPosts(ctx, items[index]);
        },
      ),

      isLoading ? Center(child: CircularProgressIndicator(),) : SizedBox.shrink(),
    ],
  );
}