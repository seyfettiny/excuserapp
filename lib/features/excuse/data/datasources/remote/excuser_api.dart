import 'package:excuserapp/locator.dart';
import 'package:excuserapp/util/random_num.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/excuse_model.dart';

class ExcuserAPI {
  final SupabaseClient _supabase;

  ExcuserAPI(this._supabase);

  Future<ExcuseModel> getRandomExcuse() async {
    final response = await getExcuseById(RandomNum.random(1, 70));
    return response;
  }

  Future<ExcuseModel> getExcuseById(int id) async {
    var locale = locator<String>();
    locale = locale.substring(0, 2);
    print('locale: $locale');
    final response =
        await _supabase.from(locale).select().eq('id', id).execute();
    return ExcuseModel.fromJson(response.data[0]);
  }

  Future<List<ExcuseModel>> getRandomExcuseList(int limit) async {
    throw UnimplementedError();
  }

  Future<ExcuseModel> getRandomExcuseByCategory(String category) async {
    print('category $category');
    List categoryList = await getExcuseListByCategory(category);
    print('categoryList ' + categoryList[0].excuse);
    final response =
        await getExcuseById(RandomNum.random(1, categoryList.length));
    print(response.excuse);
    return response;
  }

  Future<List<ExcuseModel>> getExcuseListByCategory(String category) async {
    var locale = locator<String>();
    locale = locale.substring(0, 2);
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
