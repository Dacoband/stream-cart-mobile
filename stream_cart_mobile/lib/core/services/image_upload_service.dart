import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class ImageUploadService {
  final Dio _dio;

  ImageUploadService(this._dio);

  Future<String?> uploadImage(XFile imageFile) async {
    try {
      print('[ImageUploadService] Starting image upload...');
      
      // Đọc bytes từ file
      Uint8List imageBytes = await imageFile.readAsBytes();
      
      // Tạo FormData cho upload (server yêu cầu field name là "Image")
      FormData formData = FormData.fromMap({
        'Image': MultipartFile.fromBytes(
          imageBytes,
          filename: imageFile.name,
          contentType: MediaType('image', _getFileExtension(imageFile.name)),
        ),
      });

      print('[ImageUploadService] Uploading to /api/image/upload...');
      
      final response = await _dio.post(
        '/api/image/upload',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      print('[ImageUploadService] Upload response: ${response.data}');
      print('[ImageUploadService] Response type: ${response.data.runtimeType}');
      print('[ImageUploadService] Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Thử parse response theo nhiều format khác nhau
        String? imageUrl;
        
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          // Thử các field name khác nhau
          imageUrl = data['imageUrl'] ?? 
                    data['url'] ?? 
                    data['data']?['imageUrl'] ??
                    data['data']?['url'] ??
                    data['result']?['imageUrl'] ??
                    data['result']?['url'];
        } else if (response.data is String) {
          // Nếu response trả về trực tiếp URL
          imageUrl = response.data as String;
        }
        
        if (imageUrl != null && imageUrl.isNotEmpty) {
          print('[ImageUploadService] Upload successful: $imageUrl');
          return imageUrl;
        }
      }

      print('[ImageUploadService] Upload failed: Invalid response or no imageUrl found');
      return null;
    } catch (e) {
      print('[ImageUploadService] Upload error: $e');
      
      // Nếu là DioException, log thêm chi tiết
      if (e is DioException) {
        print('[ImageUploadService] Status code: ${e.response?.statusCode}');
        print('[ImageUploadService] Response data: ${e.response?.data}');
        print('[ImageUploadService] Request data: ${e.requestOptions.data}');
        print('[ImageUploadService] Headers: ${e.requestOptions.headers}');
      }
      
      return null;
    }
  }

  String _getFileExtension(String filename) {
    return filename.split('.').last.toLowerCase();
  }
}

// Response model cho image upload
class ImageUploadResponse {
  final String imageUrl;

  ImageUploadResponse({required this.imageUrl});

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) {
    return ImageUploadResponse(
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
