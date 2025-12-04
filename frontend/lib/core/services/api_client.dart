import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/api_constants.dart';
import 'storage_service.dart';

/// Client API avec Dio
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  late Dio _dio;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor pour ajouter le token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageService.instance.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token expiré, essayer de refresh
            final refreshToken = await StorageService.instance.getRefreshToken();
            if (refreshToken != null) {
              try {
                final response = await _dio.post(
                  ApiConstants.refreshToken,
                  data: {'refresh_token': refreshToken},
                );
                final newToken = response.data['token'];
                await StorageService.instance.saveToken(newToken);
                
                // Retry la requête originale
                error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                final retryResponse = await _dio.request(
                  error.requestOptions.path,
                  options: Options(
                    method: error.requestOptions.method,
                    headers: error.requestOptions.headers,
                  ),
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                );
                return handler.resolve(retryResponse);
              } catch (e) {
                // Refresh échoué, déconnexion
                await StorageService.instance.clearAuth();
                return handler.reject(error);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );

    // Logger en développement (seulement si pas en mode mock)
    if (const bool.fromEnvironment('dart.vm.product') == false && 
        !ApiConstants.useMockData) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }

    _initialized = true;
  }

  Dio get dio => _dio;
}

