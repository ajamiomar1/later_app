import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/services.dart';

import 'package:later_app/src/Services/ContentStreamService.dart';
import 'package:later_app/src/States/HomeViewState.dart';
import 'package:later_app/src/Support/Database/DB.dart';

part 'HomeViewController.g.dart';

@riverpod
class HomeViewController extends _$HomeViewController {
  static const _platform = MethodChannel('com.example.later_app/share_handler');
  static const _pageSize = 1;

  final PagingController<int, Map<String, dynamic>> pagingController =
  PagingController(firstPageKey: 0);

  @override
  Future<HomeViewState> build() async {
    Logger().i("Building HomeViewController");

    ref.watch(getContentProvider);

    // Setup pagination listener
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    // Check if opened from share intent and process
    await _handleInitialSharing();

    // Initial page load
    return await _fetchInitialPage();
  }

  Future<HomeViewState> _fetchInitialPage() async {
    try {
      // Fetch first page of database content
      var dbData = await DB.instance.query(
          'shared_content',
          limit: _pageSize,
          offset: 0,
          orderBy: 'creation_date DESC'
      );

      // Update paging controller
      if (dbData.length < _pageSize) {
        pagingController.appendLastPage(dbData);
      } else {
        pagingController.appendPage(dbData, 1);
      }

      return HomeViewState(sharedContent: dbData);
    } catch (error) {
      pagingController.error = error;
      Logger().e('Error fetching initial page', error: error);
      return HomeViewState(sharedContent: []);
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // Fetch database content with pagination
      var dbData = await DB.instance.query(
          'shared_content',
          limit: _pageSize,
          offset: pageKey * _pageSize,
          orderBy: 'creation_date DESC'
      );

      final isLastPage = dbData.length < _pageSize;

      if (isLastPage) {
        pagingController.appendLastPage(dbData);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(dbData, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
      Logger().e('Error fetching page', error: error);
    }
  }

  Future<void> _handleInitialSharing() async {
    try {
      // Existing initial sharing logic remains the same
      var results = await FlutterSharingIntent.instance.getInitialSharing();

      if (results.isNotEmpty) {
        await _platform.invokeMethod('preventClose');

        for (var e in results) {
          if (e.value != null) {
            try {
              var value = await _processShareContent(e.value!);
              await DB.instance.insert('shared_content', value);

              Logger().i('Processed shared content: ${value['title']}');
            } catch (error) {
              Logger().e('Error processing shared content', error: error);
            }
          }
        }

        await _platform.invokeMethod('closeApp');
      }
    } catch (error) {
      Logger().e('Error in initial sharing process', error: error);

      try {
        await _platform.invokeMethod('closeApp');
      } catch (closeError) {
        Logger().e('Error closing app', error: closeError);
      }
    }
  }

  Future<Map<String, dynamic>> _processShareContent(String url) async {
    try {
      return await fetchOpenGraphData(url);
    } catch (error) {
      Logger().e('Failed to fetch Open Graph data', error: error);

      return {
        'title': 'Shared Content',
        'description': 'Unable to fetch details',
        'image': '',
        'original_url': url
      };
    }
  }

  void dispose() {
    pagingController.dispose();
    dispose();
  }
}