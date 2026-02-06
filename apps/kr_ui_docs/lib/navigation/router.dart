import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kr_ui/kr_ui.dart';
import '../main.dart';
import '../pages/home_page.dart';
import '../pages/components_page.dart';
import '../pages/getting_started_page.dart';
import '../widgets/component_showcase.dart';
import '../config/component_registry.dart';

class AppRouter {
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: '/',
    navigatorKey: KruiInitializer.navigatorKey,
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return ShowcaseHomePage(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
            ),
          ),
          GoRoute(
            path: '/components',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ComponentsPage(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id'];
                  final component = ComponentRegistry.all.firstWhere(
                    (c) => c.id == id,
                    orElse: () => ComponentRegistry.all.first,
                  );
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: ComponentShowcase(component: component),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/getting-started',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const GettingStartedPage(),
            ),
          ),
        ],
      ),
    ],
  );
}
