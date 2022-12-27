import 'package:excuserapp/data/models/excuse_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should return a valid model', () {
    //arrange
    final excuse = ExcuseModel(
      id: 1,
      excuse: 'My dog ate my homework',
      category: 'school',
    );
    //act
    //assert
    expect(excuse.id, 1);
    expect(excuse.excuse, 'My dog ate my homework');
    expect(excuse.category, 'school');
  });

  test('should correctly copy with new values', () {
    //arrange
    final model = ExcuseModel(
      id: 1,
      excuse: 'I forgot my homework',
      category: 'school',
    );
    const id = 2;
    const excuse = 'I was running late';
    const category = 'work';

    //act
    final newModel = model.copyWith(id: id, excuse: excuse, category: category);

    //assert
    expect(newModel.id, id);
    expect(newModel.excuse, excuse);
    expect(newModel.category, category);
  });

  test('should correctly convert from JSON', () {
    //arrange
    const id = 1;
    const excuse = 'I forgot my homework';
    const category = 'school';
    final json = {'id': id, 'excuse': excuse, 'category': category};

    //act
    final model = ExcuseModel.fromJson(json);

    //assert
    expect(model.id, id);
    expect(model.excuse, excuse);
    expect(model.category, category);
  });

  test('should correctly convert to JSON', () {
    //arrange
    const id = 1;
    const excuse = 'I forgot my homework';
    const category = 'school';
    final model = ExcuseModel(
      id: id,
      excuse: excuse,
      category: category,
    );

    //act
    final json = model.toJson();

    //assert
    expect(json['id'], id);
    expect(json['excuse'], excuse);
    expect(json['category'], category);
  });
}
