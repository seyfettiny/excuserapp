import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass_kit/glass_kit.dart';

import '../../../../constants/app_constants.dart';
import '../../../../locator.dart';
import '../cubit/randomcategoryexcuse/cubit/random_category_excuse_cubit.dart';
import 'loading_widget.dart';

class ExcuseByCategoryWidget extends StatefulWidget {
  const ExcuseByCategoryWidget({Key? key}) : super(key: key);

  @override
  State<ExcuseByCategoryWidget> createState() => _ExcuseByCategoryWidgetState();
}

class _ExcuseByCategoryWidgetState extends State<ExcuseByCategoryWidget> {
  var _excuseCategory = 'family';
  var locale;
  var _excuse = '';
  @override
  void initState() {
    super.initState();
    locale = locator<String>().substring(0, 2);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: GlassContainer.clearGlass(
        width: MediaQuery.of(context).size.width * 0.9,
        borderRadius: BorderRadius.circular(24),
        height: 240,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Center(
                child: BlocBuilder<RandomCategoryExcuseCubit,
                    RandomCategoryExcuseState>(
                  builder: (context, state) {
                    if (state is RandomCategoryExcuseInitial) {
                      context
                          .read<RandomCategoryExcuseCubit>()
                          .getRandomExcuseByCategory(_excuseCategory);
                    }
                    if (state is RandomCategoryExcuseLoading) {
                      return const LoadingWidget();
                    } else if (state is RandomCategoryExcuseError) {
                      return const Center(
                          child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ));
                    } else if (state is RandomCategoryExcuseLoaded) {
                      _excuse = state.excuse.excuse;
                      return Text(
                        state.excuse.excuse,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
            Wrap(
              runSpacing: -10,
              spacing: 10,
              children: [
                ...AppConstants.categoriesEN.map((category) {
                  return ChoiceChip(
                    label: Text(locale == 'en'
                        ? category
                        : AppConstants.categoriesTR.elementAt(
                            AppConstants.categoriesEN.indexOf(category))),
                    selected: _excuseCategory == category.toLowerCase(),
                    selectedColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                        color: _excuseCategory == category.toLowerCase()
                            ? Colors.white
                            : Colors.black),
                    onSelected: (bool isSelected) {
                      setState(() {
                        _excuseCategory = category.toLowerCase();
                        print(_excuseCategory);
                      });
                    },
                  );
                }).toList(),
              ],
            ),
            Stack(
              children: [
                Center(
                    child: OutlinedButton(
                  onPressed: () {
                    context
                        .read<RandomCategoryExcuseCubit>()
                        .getRandomExcuseByCategory(_excuseCategory);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    locale == 'en'
                        ? AppConstants.anotherExcuseEN
                        : AppConstants.anotherExcuseTR,
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: _excuse));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(locale == 'en'
                            ? AppConstants.copiedEN
                            : AppConstants.copiedTR),
                      ));
                    },
                    icon: const Icon(Icons.copy),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
