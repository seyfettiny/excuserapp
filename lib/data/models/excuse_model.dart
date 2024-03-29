import '../../domain/entities/excuse.dart';

class ExcuseModel extends Excuse {
  ExcuseModel({
    required super.id,
    required super.excuse,
    required super.category,
    super.locale,
  });

  ExcuseModel copyWith({
    required int id,
    required String excuse,
    required String category,
  }) =>
      ExcuseModel(
        id: id,
        excuse: excuse,
        category: category,
      );

  factory ExcuseModel.fromJson(Map<String, dynamic> json) => ExcuseModel(
        id: json["id"],
        excuse: json["excuse"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "excuse": excuse,
        "category": category,
      };
}
