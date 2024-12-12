import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
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
  final int pageSize = 10;
  int currentPage = 0;

  @override
  Future<HomeViewState> build() async {
    Logger().i("Building HomeViewController");

    ref.watch(getContentProvider);

    // Check if opened from share intent and process
    await _handleInitialSharing();

    // Fetch existing database content
    var dbData = await DB.instance.query(
        'shared_content',
        limit: pageSize,
        offset: currentPage * pageSize,
        orderBy: 'creation_date DESC'
    );

    return HomeViewState(sharedContent: dbData);
  }

  Future<void> _handleInitialSharing() async {
    try {
      // Only proceed if opened from share intent
      var results = await FlutterSharingIntent.instance.getInitialSharing();

      if (results.isNotEmpty) {
        // Prevent immediate app closure
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

        // Close the app after processing
        await _platform.invokeMethod('closeApp');
      }
    } catch (error) {
      Logger().e('Error in initial sharing process', error: error);

      // Ensure we still try to close the app
      try {
        await _platform.invokeMethod('closeApp');
      } catch (closeError) {
        Logger().e('Error closing app', error: closeError);
      }
    }
  }

  Future<Map<String, dynamic>> _processShareContent(String url) async {
    try {
      // Your existing fetchOpenGraphData logic
      return await fetchOpenGraphData(url);
    } catch (error) {
      Logger().e('Failed to fetch Open Graph data', error: error);

      // Fallback content if fetching fails
      return {
        'title': 'Shared Content',
        'description': 'Unable to fetch details',
        'image': '',
        'original_url': url
      };
    }
  }
}