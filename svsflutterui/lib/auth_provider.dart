import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svsflutterui/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  /// Check if the user is authenticated
  bool get isAuthenticated => _token != null;

  /// Load token from local storage on app start
  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    notifyListeners();
  }

  /// Login and store token in local storage
  Future<void> login(String username, String password) async {
    final response = await ApiService().login(username, password);
    _token = response['token'] as String?;
    if (_token != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
    }
    notifyListeners();
  }

  /// Logout and remove token from local storage
  Future<void> logout() async {
    _token = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    notifyListeners();
  }

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void clearToken() {
    _token = null;
    notifyListeners();
  }
}
