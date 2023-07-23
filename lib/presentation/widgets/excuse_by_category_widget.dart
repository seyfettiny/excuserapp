import '../../util/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass_kit/glass_kit.dart';

import '../cubit/randomcategoryexcuse/random_category_excuse_cubit.dart';

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
                          .watch<RandomCategoryExcuseCubit>()
                          .getRandomExcuseByCategory().then((value) => null);
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
                    context.l10n.anotherExcuse,
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      _copyToClipboard(context);
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

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(
      ClipboardData(text: context.read<RandomCategoryExcuseCubit>().excuse),
    ).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.copied),
        ),
      );
    }).onError((error, stackTrace) {
      debugPrint('error: $error, stackTrace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.copyError),
        ),
      );
    });
  }

  Widget _buildWidgetForState(
      BuildContext context, RandomCategoryExcuseState state) {
    switch (state.runtimeType) {
      case RandomCategoryExcuseLoading:
        return const LoadingWidget();
      case RandomCategoryExcuseError:
      debugPrint('error: ${(state as RandomCategoryExcuseError).error}');
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
