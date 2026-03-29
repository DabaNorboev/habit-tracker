import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_router.dart';
import 'repositories/habit_repository.dart';
import 'services/notification_service.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализируем Hive
  await HabitRepository.init();
  
  // Инициализируем аутентификацию
  await AuthService().init();
  
  // Инициализируем уведомления
  await NotificationService().init();
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return MaterialApp(
      title: 'Habit Tracker',
      theme: AppTheme.darkTheme,
      home: currentUser == null ? const LoginScreen() : const HomeScreen(),
    );
  }
}