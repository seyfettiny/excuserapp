import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/excuse_model.dart';

class ExcuserAPI {
  final SupabaseClient _supabase;
  ExcuserAPI(this._supabase);
  Future<ExcuseModel> getRandomExcuse() async {
    Random random = Random();
    int randomNumber = random.nextInt(69) + 1;
    final response =
        await _supabase.from('en').select().eq('id', randomNumber).execute();
    return ExcuseModel.fromJson(response.data[0]);
  }

  Future<ExcuseModel> getExcuseById(int id) async {
    throw UnimplementedError();
  }

  Future<List<ExcuseModel>> getRandomExcuseList(int limit) async {
    throw UnimplementedError();
  }

  Future<ExcuseModel> getRandomExcuseByCategory(String category) async {
    final categoryRange = await _supabase
        .from('en')
        .select()
        .match({'category': category}).execute();
    List categoryRangeList = categoryRange.data;
    Random random = Random();
    int randomNumber = random.nextInt(categoryRangeList.length - 1) + 1;
    print('randomNumber ${randomNumber}');
    final response =
        await _supabase.from('en').select().eq('id', randomNumber).execute();
    print('response ${response.data}');
    return ExcuseModel.fromJson(response.data[0]);
  }

  Future<List<ExcuseModel>> getExcuseListByCategory(
      String category, int limit) async {
    throw UnimplementedError();
  }
}
