import 'dart:async';

import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../widgets/loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  Comment({this.itemId, this.itemMap, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemModel>(
      future: itemMap[itemId],
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        final item = snapshot.data;
        final children = <Widget>[
          ListTile(
            title: _buildText(item),
            subtitle: item.by == "" ? Text("Deleted") : Text(item.by),
            contentPadding: EdgeInsets.only(
              left: (depth + 1) * 16.0,
              right: 16.0,
            ),
          ),
          Divider(),
        ];
        children.addAll(item.kids.map((kidId) {
          return Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Comment(
              itemId: kidId,
              itemMap: itemMap,
              depth: depth + 1,
            ),
          );
        }));

        return Column(
          children: children,
        );
      },
    );
  }

  Widget _buildText(ItemModel item) {
    final text = item.text
        .replaceAll('&#x27', '\'')
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');
    return Text(text);
  }
}
