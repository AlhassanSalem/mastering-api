import 'package:dio/dio.dart';
import 'package:mastering_api/cache/cache_helper.dart';
import 'package:mastering_api/core/api/end_points.dart';

class ApiInterceptors extends Interceptor{

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiKeys.token] = CacheHelper().getData(key: ApiKeys.token) != null ? 'FOODAPI ${CacheHelper().getData(key: ApiKeys.token)}' : null;
    super.onRequest(options, handler);
  }


}