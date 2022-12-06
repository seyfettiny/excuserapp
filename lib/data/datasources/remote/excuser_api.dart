import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:excuserapp/data/models/excuse_model.dart';
import 'package:excuserapp/util/get_locale.dart';
import 'package:excuserapp/util/random_num.dart';

class ExcuserAPI {
  final SupabaseClient _supabase;
  final locale = GetLocale.getLocale();
  ExcuserAPI(this._supabase);

  Future<ExcuseModel> getRandomExcuse() async {
    final response = await getExcuseById(RandomNum.random(1, 70));
    return response;
  }

  Future<ExcuseModel> getExcuseById(int id) async {
    final response =
        await _supabase.from(locale).select().eq('id', id).execute();
    return ExcuseModel.fromJson(response.data[0]);
  }

  Future<ExcuseModel> getRandomExcuseByCategory(String category) async {
    List categoryList = await getExcuseListByCategory(category);
    final randomIndex = RandomNum.random(0, categoryList.length);
    return categoryList[randomIndex];
  }

  Future<List<ExcuseModel>> getExcuseListByCategory(String category) async {
    final categoryRange = await _supabase
        .from(locale)
        .select()
        .match({'category': category}).execute();
    final result = (categoryRange.data as List)
        .map((category) => ExcuseModel.fromJson(category))
        .toList();
    return result;
  }
}
