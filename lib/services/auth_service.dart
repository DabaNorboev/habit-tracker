import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  static const String usersBoxName = 'users';

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  late Box<User> _usersBox;
  User? _currentUser;

  User? get currentUser => _currentUser;
  String? get currentUserId => _currentUser?.id;

  Future<void> init() async {
    Hive.registerAdapter(UserAdapter());
    _usersBox = await Hive.openBox<User>(usersBoxName);
    
    // Восстановить сессию пользователя если была ранее
    await restoreSession();
  }

  // Регистрация нового пользователя
  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Проверить, существует ли пользователь с таким email
      final existingUser = _usersBox.values
          .where((user) => user.email == email)
          .toList();
      
      if (existingUser.isNotEmpty) {
        return false; // Пользователь уже существует
      }

      // Хешировать пароль (простое хеширование для примера)
      final passwordHash = sha256.convert(password.codeUnits).toString();

      // Создать нового пользователя
      final user = User(
        id: const Uuid().v4(),
        email: email,
        passwordHash: passwordHash,
        name: name,
        createdAt: DateTime.now(),
      );

      await _usersBox.add(user);
      _currentUser = user;
      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // Вход в аккаунт
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final passwordHash = sha256.convert(password.codeUnits).toString();

      final users = _usersBox.values
          .where((user) => user.email == email && user.passwordHash == passwordHash)
          .toList();

      if (users.isEmpty) {
        return false; // Неверный email или пароль
      }

      _currentUser = users.first;
      // Сохранить ID пользователя для восстановления сессии
      await _saveCurrentUserId(_currentUser!.id);
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Выход из аккаунта
  Future<void> logout() async {
    _currentUser = null;
    await _clearCurrentUserId();
  }

  // Восстановить сессию пользователя
  Future<void> restoreSession() async {
    try {
      final prefs = await Hive.openBox('appPrefs');
      final userId = prefs.get('currentUserId');
      
      if (userId != null) {
        final users = _usersBox.values
            .where((user) => user.id == userId)
            .toList();
        
        if (users.isNotEmpty) {
          _currentUser = users.first;
        }
      }
    } catch (e) {
      print('Session restore error: $e');
    }
  }

  // Сохранить ID текущего пользователя
  Future<void> _saveCurrentUserId(String userId) async {
    try {
      final prefs = await Hive.openBox('appPrefs');
      await prefs.put('currentUserId', userId);
    } catch (e) {
      print('Save user ID error: $e');
    }
  }

  // Удалить ID текущего пользователя
  Future<void> _clearCurrentUserId() async {
    try {
      final prefs = await Hive.openBox('appPrefs');
      await prefs.delete('currentUserId');
    } catch (e) {
      print('Clear user ID error: $e');
    }
  }

  // Проверить, авторизован ли пользователь
  bool isAuthenticated() {
    return _currentUser != null;
  }

  // Удалить аккаунт
  Future<bool> deleteAccount(String password) async {
    try {
      if (_currentUser == null) return false;

      final passwordHash = sha256.convert(password.codeUnits).toString();
      if (_currentUser!.passwordHash != passwordHash) {
        return false; // Неверный пароль
      }

      // Найти индекс пользователя и удалить
      final index = _usersBox.values.toList().indexWhere((user) => user.id == _currentUser!.id);
      if (index != -1) {
        await _usersBox.deleteAt(index);
      }

      _currentUser = null;
      await _clearCurrentUserId();
      return true;
    } catch (e) {
      print('Delete account error: $e');
      return false;
    }
  }
}
