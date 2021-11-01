import 'package:dio/dio.dart';

class RequestsHandler {
  late final Dio _dio;

  RequestsHandler(
    String baseUrl, {
    Map<String, dynamic>? headers,
    ResponseType? responseType,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: headers,
      responseType: responseType ?? ResponseType.json,
    ));
  }

  Future<NetworkResponse> getRequest(String path) async {
    final res = await _dio.get(path);
    return NetworkResponse(res.data, res.statusCode);
  }

  Future<NetworkResponse> postRequest(String path, [dynamic body]) async {
    late final Response res;
    if (body != null) {
      res = await _dio.post(path, data: body);
    } else {
      res = await _dio.post(path);
    }
    return NetworkResponse(res.data, res.statusCode);
  }

  Future<NetworkResponse> putRequest(String path, [dynamic body]) async {
    late final Response res;
    if (body != null) {
      res = await _dio.put(path, data: body);
    } else {
      res = await _dio.put(path);
    }
    return NetworkResponse(res.data, res.statusCode);
  }

  Future<NetworkResponse> deleteRequest(String path) async {
    final res = await _dio.delete(path);
    return NetworkResponse(res.data, res.statusCode);
  }
}

class NetworkResponse {
  final int? status;
  final dynamic data;

  NetworkResponse(this.data, [this.status]);
}
