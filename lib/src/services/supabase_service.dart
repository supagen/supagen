import 'package:dio/dio.dart';

class SupabaseService {
  final String projectUrl;
  final String anonKey;

  SupabaseService({
    required this.projectUrl,
    required this.anonKey,
  });

  Future<Map<String, dynamic>> getTableDefinitions() async {
    final dio = Dio(BaseOptions(
      baseUrl: projectUrl,
      headers: {
        'apikey': anonKey,
        'Content-Type': 'application/json',
      },
    ));

    final response = await dio.get('/rest/v1/');
    return response.data['definitions'];
  }
}
