import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/services.dart';
import 'package:later_app/src/Services/ContentStreamService.dart';
import 'package:later_app/src/States/SearchViewState.dart';
import 'package:later_app/src/Support/Database/DB.dart';

part 'SearchViewController.g.dart';

@riverpod
@riverpod
class SearchViewController extends _$SearchViewController {
  final int pageSize = 10;

  @override
  Future<SearchViewState> build() async {
    Logger().i("Building SearchViewController");
    return SearchViewState(sharedContent: []);
  }

  Future<List<Map<String, dynamic>>> fetchPage(String keyword, int pageKey) async {
    Logger().i("Fetching page $pageKey for keyword: $keyword");

    if (keyword.isEmpty) {
      Logger().i("Query is empty, returning empty list");
      return [];
    }

    try {
      final dbData = await DB.instance.query(
        'shared_content',
        limit: pageSize,
        offset: pageKey * pageSize,
        orderBy: 'creation_date DESC',
      );

      Logger().i("Database returned: ${dbData.length} items");
      return dbData;
    } catch (e) {
      Logger().e("Error fetching search results: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> search(String keyword) async {
    Logger().i("Searching for: $keyword");
    try {
      final dbData = await DB.instance.searchQuery('shared_content', keyword);
      return dbData;
    } catch (e) {
      Logger().e("Error in search: $e");
      return [];
    }
  }
}
