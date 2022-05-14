import 'package:dio/dio.dart';

import '../../models/excuse_model.dart';

class ExcuserAPI {
  static const String _baseUrl = 'https://excuser.herokuapp.com/v1/excuse';

  final Dio _dio;

  ExcuserAPI(this._dio) {
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 5000;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }
  Future<ExcuseModel> getRandomExcuse() async {
    final response = await _dio.get(_baseUrl);
    return ExcuseModel.fromJson(response.data[0]);
  }

  Future<ExcuseModel> getExcuseById(int id) async {
    final response = await _dio.get(_baseUrl + '/id/$id');
    return ExcuseModel.fromJson(response.data);
  }

  Future<List<ExcuseModel>> getRandomExcuseList(int limit) async {
    final response = await _dio.get(_baseUrl + '/$limit');
    return response.data.map((e) => ExcuseModel.fromJson(e)).toList();
  }

  Future<ExcuseModel> getRandomExcuseByCategory(String category) async {
    final response = await _dio.get(_baseUrl + '/$category/');
    return ExcuseModel.fromJson(response.data[0]);
  }

  Future<List<ExcuseModel>> getExcuseListByCategory(
      String category, int limit) async {
    final response = await _dio.get(_baseUrl + '/$category/$limit');
    return (response.data as List)
        .map((excuse) => ExcuseModel.fromJson(excuse))
        .toList();
  }
}
