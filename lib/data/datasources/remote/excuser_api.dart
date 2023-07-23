import '../local/database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/excuse_model.dart';

class ExcuserAPI {
  final SupabaseClient _supabase;
  final ExcuseDatabase database;
  ExcuserAPI(this._supabase, this.database);

  Future<ExcuseModel> getRandomExcuse(int randomId) async {
    final response = await getExcuseById(randomId);
    return response;
  }

  Future<ExcuseModel> getExcuseById(int id) async {
    final locale = await database.getLocale();
    final response = await _supabase
        .from(locale)
        .select()
        .eq('id', id)
        .withConverter<ExcuseModel>((data) => ExcuseModel.fromJson(data[0]));
    return response;
  }

  Future<ExcuseModel> getRandomExcuseByCategory(
      String category, int randomId) async {
    final categoryList = await getExcuseListByCategory(category);
    return categoryList[randomId];
  }

  Future<List<ExcuseModel>> getExcuseListByCategory(String category) async {
    final locale = await database.getLocale();
    final excuseList =
        await _supabase.from(locale).select().match({'category': category});
    final result = (excuseList as List)
        .map((category) => ExcuseModel.fromJson(category))
        .toList();
    return result;
  }
}
