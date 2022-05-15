import 'dart:ui';

import 'package:excuserapp/features/excuse/presentation/widgets/loading_widget.dart';
import 'package:glass_kit/glass_kit.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/randomexcuse/random_excuse_cubit.dart';

class RandomExcuseWidget extends StatelessWidget {
  RandomExcuseWidget({Key? key}) : super(key: key);
  var _excuse = '';

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
        borderWidth: 0,
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
                      child:
                          BlocBuilder<RandomExcuseCubit, RandomExcuseState>(
                        builder: (context, state) {
                          if (state is RandomExcuseInitial) {
                            context
                                .read<RandomExcuseCubit>()
                                .getRandomExcuse();
                          }
                          if (state is RandomExcuseLoading) {
                            return const LoadingWidget();
                          } else if (state is RandomExcuseError) {
                            return const Center(
                                child: Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            ));
                          } else if (state is RandomExcuseLoaded) {
                            _excuse = state.excuse.excuse;
                            print(state.excuse.category);

                            return Text(
                              _excuse,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
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
                    child: const Text(
                      'Get another one',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: _excuse));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        content: Text('Copied to clipboard'),
                      ));
                      print(_excuse);
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
