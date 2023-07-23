import '../../util/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass_kit/glass_kit.dart';

import '../cubit/randomexcuse/random_excuse_cubit.dart';
import 'loading_widget.dart';

class RandomExcuseWidget extends StatelessWidget {
  const RandomExcuseWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: GlassContainer.clearGlass(
        height: 170,
        width: MediaQuery.of(context).size.width * 0.9,
        borderRadius: BorderRadius.circular(24),
        blur: 2,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: BlocBuilder<RandomExcuseCubit, RandomExcuseState>(
                        builder: (context, state) {
                          if (state is RandomExcuseInitial) {
                            context.watch<RandomExcuseCubit>().getRandomExcuse();
                          }
                          return _buildWidgetForState(context, state);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Center(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<RandomExcuseCubit>().getRandomExcuse();
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
                  ),
                ),
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
      ClipboardData(text: context.read<RandomExcuseCubit>().excuse),
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

  Widget _buildWidgetForState(BuildContext context, RandomExcuseState state) {
    switch (state.runtimeType) {
      case RandomExcuseLoading:
        return const LoadingWidget();
      case RandomExcuseError:
      debugPrint('error: ${(state as RandomExcuseError).error}');
        return const Center(
          child: Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
        );
      case RandomExcuseLoaded:
        return Text(
          (state as RandomExcuseLoaded).excuse.excuse,
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
