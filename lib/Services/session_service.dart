import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _keyUserId = 'session_user_id';
  static const _keyUserName = 'session_user_name';
  static const _keyUserEmail = 'session_user_email';
  static const _keyRemember = 'session_remember';

  static Future<void> save({
    required String userId,
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setBool(_keyRemember, true);
  }

  static Future<SessionData?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_keyRemember) ?? false;
    if (!remember) return null;

    final userId = prefs.getString(_keyUserId);
    if (userId == null || userId.isEmpty) return null;

    return SessionData(
      userId: userId,
      name: prefs.getString(_keyUserName) ?? '',
      email: prefs.getString(_keyUserEmail) ?? '',
    );
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    await prefs.setBool(_keyRemember, false);
  }
}

class SessionData {
  final String userId;
  final String name;
  final String email;

  SessionData({
    required this.userId,
    required this.name,
    required this.email,
  });
}
