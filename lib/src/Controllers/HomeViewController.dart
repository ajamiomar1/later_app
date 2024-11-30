

import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:logger/logger.dart';
// import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:later_app/src/Services/ContentStreamService.dart';
import 'package:later_app/src/States/HomeVIewState.dart';
import 'package:later_app/src/Support/Database/DB.dart';


part 'HomeViewController.g.dart';

@riverpod
class HomeViewController extends _$HomeViewController {
  @override
  Future<HomeViewState> build() async {

    Logger().i("Building HomeViewController");

    var contentStream = ref.watch(getContentProvider);

    await getInitialMedia();

    var dbData = await DB.instance.query('shared_content');

    return HomeViewState(
        sharedContent: dbData
    );
  }

  //TODO::OA
  Future<void> getInitialMedia() async {
    var results = await FlutterSharingIntent.instance.getInitialSharing();
    results.map((e){
      fetchOpenGraphData(e.value ?? "").then((value) =>  DB.instance.insert('shared_content', value));
      Logger().f(e);
    }).toList();
  }
}