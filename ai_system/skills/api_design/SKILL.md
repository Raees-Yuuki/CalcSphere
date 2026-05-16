# API Design Skill

## Dio Setup
```dart
final dio = Dio(BaseOptions(
  connectTimeout: Duration(seconds: 5),
  receiveTimeout: Duration(seconds: 10),
));
// Add interceptors: logging, caching, retry
```

## Caching Strategy
- Cache key: URL + query params
- TTL: 1 hour for currency rates
- Storage: Hive box 'currency_cache'
- Always return cache first, then update in background

## Error Handling
```dart
try {
  final response = await dio.get(url);
  return ApiSuccess(data: response.data);
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    return ApiError(message: 'No internet connection');
  }
  return ApiError(message: e.message ?? 'Unknown error');
}
```

## Rules
- Never expose raw Dio response to UI layer
- Always map API response to domain model
- Always handle: timeout, no internet, 4xx, 5xx
- Log all API calls in debug mode only