import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _user;
  String? _token;
  bool _isLoading = true;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');

    if (_token != null) {
      try {
        _user = await _authService.fetchProfile(_token!);
      } catch (e) {
        // Token expired or invalid
        await logout();
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> startLogin(String username, String password) async {
    final data = await _authService.login(username, password);
    await _handleAuthSuccess(data);
  }

  Future<void> startRegister(String username, String email, String password) async {
    final data = await _authService.register(username, email, password);
    await _handleAuthSuccess(data);
  }

  Future<void> _handleAuthSuccess(Map<String, dynamic> responseData) async {
    if (responseData['success'] == true) {
      _token = responseData['token'];
      _user = UserModel.fromJson(responseData['user']);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', _token!);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    notifyListeners();
  }
}
