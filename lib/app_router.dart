import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'providers/auth_provider.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    // Проверка аутентификации будет в main.dart с использованием StreamBuilder
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/progress/:habitId',
      builder: (context, state) {
        final habitId = state.pathParameters['habitId']!;
        return ProgressScreen(habitId: habitId);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
