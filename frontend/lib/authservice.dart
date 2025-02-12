import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  late final FlutterSecureStorage storage;

  AuthService._internal() {
    storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }

  static AndroidOptions _getAndroidOptions() {
    return const AndroidOptions(
      encryptedSharedPreferences: true,
    );
  }

  final String baseUrl = dotenv.env['API_URL'] ?? 'API_URL_NOT_FOUND';

  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Registration successful'};
      } else {
        final errorData = json.decode(response.body);
        return {'success': false, 'message': errorData['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Registration failed: $e'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await storage.write(key: 'jwt_token', value: data['token']);
        await storage.write(key: 'user_email', value: data['user']['email']);
        await storage.write(key: 'user_id', value: data['user']['id']);
        return {'success': true, 'user': data['user']};
      } else {
        final errorData = json.decode(response.body);
        return {'success': false, 'message': errorData['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Login failed: $e'};
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'user_email');
    await storage.delete(key: 'user_id');
  }

  Future<bool> isLoggedIn() async {
    return await storage.read(key: 'jwt_token') != null;
  }

  // New methods for profile functionality
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await storage.read(key: 'jwt_token');
      final userId = await storage.read(key: 'user_id');

      if (token == null || userId == null) {
        return {
          'success': false,
          'message': 'Not authenticated',
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/profile/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'profile': data['profile'],
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to fetch profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error fetching profile: $e',
      };
    }
  }

  Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> updates) async {
    try {
      final token = await storage.read(key: 'jwt_token');
      final userId = await storage.read(key: 'user_id');

      if (token == null || userId == null) {
        return {
          'success': false,
          'message': 'Not authenticated',
        };
      }

      final response = await http.put(
        Uri.parse('$baseUrl/api/profile/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(updates),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (updates.containsKey('email')) {
          await storage.write(key: 'user_email', value: updates['email']);
        }

        return {
          'success': true,
          'profile': data['profile'],
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to update profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error updating profile: $e',
      };
    }
  }
}
