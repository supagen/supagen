import 'package:dio/dio.dart';

class SupabaseService {
  final String supabaseUrl;
  final String anonKey;

  SupabaseService({
    required this.supabaseUrl,
    required this.anonKey,
  });

  Future<Map<String, dynamic>> getTableDefinitions() async {
    final dio = Dio(BaseOptions(
      baseUrl: supabaseUrl,
      headers: {
        'apikey': anonKey,
        'Content-Type': 'application/json',
      },
    ));

    final response = await dio.get('/rest/v1/');
    return response.data['definitions'];
  }
}
