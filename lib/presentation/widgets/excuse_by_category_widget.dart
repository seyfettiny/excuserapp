import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass_kit/glass_kit.dart';

import 'package:excuserapp/constants/app_constants.dart';
import 'package:excuserapp/presentation/cubit/randomcategoryexcuse/cubit/random_category_excuse_cubit.dart';
import 'package:excuserapp/util/copy_to_clipboard.dart';
import 'package:excuserapp/util/get_locale.dart';

import 'excuse_category_choices.dart';
import 'loading_widget.dart';

class ExcuseByCategoryWidget extends StatelessWidget {
  const ExcuseByCategoryWidget({Key? key}) : super(key: key);

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
                          .getRandomExcuseByCategory();
                    }
                    return _buildWidgetForState(context, state);
                  },
                ),
              ),
            ),
            const ExcuseCategoryChoices(),
            Stack(
              children: [
                Center(
                    child: OutlinedButton(
                  onPressed: () {
                    context
                        .read<RandomCategoryExcuseCubit>()
                        .getRandomExcuseByCategory();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    GetLocale.getLocale() == 'en'
                        ? AppConstants.anotherExcuseEN
                        : AppConstants.anotherExcuseTR,
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () async {
                      await CopyClipboard.copyToClipboard(context,
                          context.read<RandomCategoryExcuseCubit>().excuse);
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

  Widget _buildWidgetForState(
      BuildContext context, RandomCategoryExcuseState state) {
    switch (state.runtimeType) {
      case RandomCategoryExcuseLoading:
        return const LoadingWidget();
      case RandomCategoryExcuseError:
        return const Center(
          child: Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
        );
      case RandomCategoryExcuseLoaded:
        return Text(
          (state as RandomCategoryExcuseLoaded).excuse.excuse,
          style: const TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        );
      default:
        return const CircularProgressIndicator();
    }
  }
}
