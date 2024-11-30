import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
// import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:later_app/src/Support/Database/DB.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'routes/router.dart'; // Import url_launcher

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DB.instance.database;

  runApp(
      ProviderScope(child: MainApp())
  );
}

class MainApp extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: goRouter,
    );
  }
}
