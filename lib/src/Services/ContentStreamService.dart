

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:html/parser.dart';
import 'package:logger/logger.dart';
// import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:later_app/src/Controllers/HomeViewController.dart';
import 'package:later_app/src/Support/Database/DB.dart';

part 'ContentStreamService.g.dart';
@riverpod
Stream<List<Map<String,dynamic>>> getContent(Ref ref) async* {

  List<Map<String,dynamic>> sharedContent = [];
  //TODO:OA
  FlutterSharingIntent.instance.getMediaStream().listen((results) {
    results.map((e){
      Logger().f(e);
      fetchOpenGraphData(e.value ?? "").then((value) {
        DB.instance.insert('shared_content', value);

        sharedContent.add(value);

      });

    }).toList();

     ref.invalidate(homeViewControllerProvider);

  }, onError: (err) {
    print("Error in sharing data stream: $err");
  });

   yield sharedContent;
}

Future<Map<String, String>> fetchOpenGraphData(String url) async {
  try {
    final http = Dio();
    final response = await http.get((url));
    Logger().i("Received OpenGraph response: ${response.statusCode}");
    if (response.statusCode == 200) {
      final document = parse(response.data);
      final metaTags = document.getElementsByTagName('meta');

      String? title, description, image;

      for (var tag in metaTags) {
        final property = tag.attributes['property'];
        final content = tag.attributes['content'];

        if (property == 'og:title') title = content;
        if (property == 'og:description') description = content;
        if (property == 'og:image') image = content;
      }

      Logger().i("OpenGraph data: $title, $description, $image");
      return {
        'title': title ?? 'No title available',
        'description': description ?? 'No description available',
        'image': image ?? '',
        'url': url
      };
    }
  } catch (e) {
    print("Error fetching OpenGraph data: $e");
  }
  return {
    'title': 'No title available',
    'description': 'No description available',
    'image': '',
  };
}
