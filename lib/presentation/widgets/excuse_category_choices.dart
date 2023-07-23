import '../../constants/app_constants.dart';
import '../cubit/randomcategoryexcuse/random_category_excuse_cubit.dart';
import '../../util/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExcuseCategoryChoices extends StatefulWidget {
  const ExcuseCategoryChoices({
    Key? key,
  }) : super(key: key);

  @override
  State<ExcuseCategoryChoices> createState() => _ExcuseCategoryChoicesState();
}

class _ExcuseCategoryChoicesState extends State<ExcuseCategoryChoices> {
  List<String> parseCategories(BuildContext context) {
    final rawList = context.l10n.categories;
    List<String> categories = [];
    rawList.split(', ').forEach((element) {
      categories.add(element);
    });
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    final categoryList = parseCategories(context);
    final categoryState = context.watch<RandomCategoryExcuseCubit>().category;
    return Wrap(
      runSpacing: -10,
      spacing: 10,
      children: [
        ...categoryList.map((category) {
          int index = categoryList.indexOf(category);
          return ChoiceChip(
            label: Text(category),
            selected: categoryState == AppConstants.categoryKeys[index],
            selectedColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
                color: categoryState == AppConstants.categoryKeys[index]
                    ? Colors.white
                    : Colors.black),
            onSelected: (bool isSelected) {
              setState(() {
                context
                    .read<RandomCategoryExcuseCubit>()
                    .changeCategory(AppConstants.categoryKeys[index]);
              });
            },
          );
        }).toList(),
      ],
    );
  }
}
