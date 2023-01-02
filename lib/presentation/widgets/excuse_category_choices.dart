import 'package:excuserapp/presentation/cubit/randomcategoryexcuse/cubit/random_category_excuse_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_constants.dart';
import '../../util/get_locale.dart';

class ExcuseCategoryChoices extends StatefulWidget {
  const ExcuseCategoryChoices({
    Key? key,
  }) : super(key: key);

  @override
  State<ExcuseCategoryChoices> createState() => _ExcuseCategoryChoicesState();
}

class _ExcuseCategoryChoicesState extends State<ExcuseCategoryChoices> {
  @override
  Widget build(BuildContext context) {
    final _category = context.read<RandomCategoryExcuseCubit>().category;
    return Wrap(
      runSpacing: -10,
      spacing: 10,
      children: [
        ...AppConstants.categoriesEN.map((category) {
          return ChoiceChip(
            label: Text(GetLocale.getLocale() == 'en'
                ? category
                : AppConstants.categoriesTR
                    .elementAt(AppConstants.categoriesEN.indexOf(category))),
            selected: _category == category.toLowerCase(),
            selectedColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
                color: _category == category.toLowerCase()
                    ? Colors.white
                    : Colors.black),
            onSelected: (bool isSelected) {
              setState(() {
                context
                    .read<RandomCategoryExcuseCubit>()
                    .changeCategory(category.toLowerCase());
              });
            },
          );
        }).toList(),
      ],
    );
  }
}
