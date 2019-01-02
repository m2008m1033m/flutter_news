import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';

class Repository {
  List<Source> sources = <Source>[
    newsDbProvider,
    NewsApiProvider(),
  ];
  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds() async {
    for (var source in sources) {
      var topIds = await source.fetchTopIds();
      if (topIds != null) {
        return topIds;
      }
    }
    return null;
  }

  Future<ItemModel> fetchItem(int id) async {
    for (var source in sources) {
      var item = await source.fetchItem(id);
      if (item != null) {
        for (var cache in caches) {
          cache.addItem(item);
        }
        return item;
      }
    }
    return null;
  }

  Future clearCache() async {
    for (var cache in caches) {
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();

  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);

  Future<int> clear();
}
