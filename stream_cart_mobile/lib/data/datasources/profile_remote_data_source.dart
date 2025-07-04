import 'package:dio/dio.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      print('[ProfileRemoteDataSource] Getting user profile from /api/auth/me');
      final response = await dio.get('/api/auth/me');
      print('[ProfileRemoteDataSource] Response: ${response.data}');
      
      // Parse response - API trả về có wrapper {success, message, data, errors}
      final responseData = response.data;
      if (responseData['success'] == true && responseData['data'] != null) {
        return UserProfileModel.fromJson(responseData['data']);
      } else {
        throw Exception('Invalid response format or failed response');
      }
    } catch (e) {
      print('[ProfileRemoteDataSource] Error getting user profile: $e');
      rethrow;
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile) async {
    try {
      print('[ProfileRemoteDataSource] Updating user profile');
      final response = await dio.put('/api/auth/me', data: profile.toJson());
      print('[ProfileRemoteDataSource] Update response: ${response.data}');
      
      return UserProfileModel.fromJson(response.data);
    } catch (e) {
      print('[ProfileRemoteDataSource] Error updating user profile: $e');
      rethrow;
    }
  }
}
