import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

abstract class AuthRepository {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();
  Future<Map<String, dynamic>?> login(String email, String password);
  Future<Map<String, dynamic>?> signup(String name, String email, String password);
}

class MockAuthRepository implements AuthRepository {
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';

  MockAuthRepository(this._storage);

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  @override
  Future<Map<String, dynamic>?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    // Mock validation
    if (email.isEmpty || password.length < 6) return null;

    const token = 'mock_jwt_token_12345';
    await saveToken(token);

    return {
      'id': 'user_001',
      'name': 'Md. Mamun',
      'email': email,
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&q=80',
      'token': token,
    };
  }

  @override
  Future<Map<String, dynamic>?> signup(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    const token = 'mock_jwt_token_signup_67890';
    await saveToken(token);

    return {
      'id': 'user_002',
      'name': name,
      'email': email,
      'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&q=80',
      'token': token,
    };
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return MockAuthRepository(storage);
});
