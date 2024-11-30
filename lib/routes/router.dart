import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:later_app/routes/routes.dart';
import 'package:later_app/src/Views/HomeView.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      name: AppRoutes.homeView.name,
      builder: (context, state) => HomeView(),
    ),
  ],
);

final goRouterProvider = Provider<GoRouter>((ref) {
  return router;
});
