import 'package:dicoding_storyapp_awal/controller/data/api/detail_api.dart';
import 'package:dicoding_storyapp_awal/controller/data/api/login_api.dart';
import 'package:dicoding_storyapp_awal/controller/data/api/register_api.dart';
import 'package:dicoding_storyapp_awal/controller/internet_controller.dart';

import 'package:dicoding_storyapp_awal/pages/detail.dart';
import 'package:dicoding_storyapp_awal/pages/list_story.dart';
import 'package:dicoding_storyapp_awal/pages/login.dart';
import 'package:dicoding_storyapp_awal/pages/new_story.dart';
import 'package:dicoding_storyapp_awal/pages/register.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('user_token');

  if (token != null) {
    _router.goNamed('liststory');
  } else {
    _router.goNamed('login');
  }
  runApp(const MyApp());
  Get.put(RegisterControllerApi());
  Get.put(LoginControllerApi());
  Get.put(StoryDetailController());
  Get.put(ConnectivityInternet());
}

final rootNavigatorKey = Get.key;
final GoRouter _router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      name: 'login',
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return LoginPage();
      },
      routes: <RouteBase>[
        GoRoute(
          name: 'register',
          path: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return RegisterPage();
          },
        ),
      ],
    ),
    GoRoute(
      name: 'liststory',
      path: "/liststory",
      builder: (BuildContext context, GoRouterState state) {
        return ListPage();
      },
      routes: <RouteBase>[
        GoRoute(
          name: 'detailstory',
          path: 'detailstory/:storyId',
          builder: (BuildContext context, GoRouterState state) {
            final storyId = state.pathParameters['storyId'] ?? "";
            return DetailPage(storyId: storyId);
          },
        ),
        GoRoute(
          name: 'addnewstory',
          path: 'addnewstory',
          builder: (BuildContext context, GoRouterState state) {
            return AddNewStory();
          },
        )
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      routeInformationProvider: _router.routeInformationProvider,
    );
  }
}
