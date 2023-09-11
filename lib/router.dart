import 'package:besports_v5/features/dashboard/dashboard_screen.dart';
import 'package:besports_v5/features/exercise/exercise_screen.dart';
import 'package:besports_v5/features/exercise/nfc/nfcView.dart';
import 'package:besports_v5/features/history/history_screen.dart';
import 'package:besports_v5/features/profile/profile_screen.dart';
import 'package:besports_v5/features/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    // GoRoute(
    //   name: MainNavigationScreen.routeName,
    //   path: "/:tab(home|search|history|profile)",
    //   builder: (context, state) {
    //     final tab = state.params["tab"]!;
    //     return MainNavigationScreen(tab: tab);
    //   },
    // ),
    GoRoute(
      path: SearchScreen.routeName,
      name: SearchScreen.routeURL,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: DashboardScreen.routeName,
      name: DashboardScreen.routeURL,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: HistoryScreen.routeName,
      name: HistoryScreen.routeURL,
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: ProfileScreen.routeName,
      name: ProfileScreen.routeURL,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: ExerciseScreen.routeURL,
      name: ExerciseScreen.routeName,
      pageBuilder: (context, state) => CustomTransitionPage(
        transitionDuration: const Duration(milliseconds: 300),
        child: const ExerciseScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final position = Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation);
          return SlideTransition(
            position: position,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: NFCScreen.routeURL,
      name: NFCScreen.routeName,
      builder: (context, state) => const NFCScreen(),
    )
  ],
);
