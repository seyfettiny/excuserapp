import 'package:shimmer/shimmer.dart';

import '../../domain/entities/excuse.dart';
import '../cubit/excuse_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RandomExcuseWidget extends StatelessWidget {
  const RandomExcuseWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Excuse _excuse = Excuse(id: 1, excuse: '', category: '');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 150,
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
                      child: BlocBuilder<ExcuseCubit, ExcuseState>(
                        builder: (context, state) {
                          if (state is ExcuseInitial) {
                            context.read<ExcuseCubit>().getRandomExcuse();
                          }
                          if (state is ExcuseLoading) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 40.0,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey,
                                    highlightColor: Colors.grey[300]!,
                                    child: Container(
                                      color: Colors.black.withAlpha(100),
                                      width: 220.0,
                                      height: 16.0,
                                    ),
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey,
                                    highlightColor: Colors.grey[300]!,
                                    child: Container(
                                      color: Colors.black.withAlpha(100),
                                      width: 150.0,
                                      height: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (state is ExcuseError) {
                            return const Center(
                                child: Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            ));
                          } else if (state is ExcuseLoaded) {
                            _excuse = state.excuse;
                            return Text(
                              _excuse.excuse.toString(),
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(
                          ClipboardData(text: _excuse.excuse.toString()));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Copied to clipboard'),
                      ));
                    },
                    icon: const Icon(Icons.copy),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                context.read<ExcuseCubit>().getRandomExcuse();
              },
              child: const Text('Get another one'),
            ),
          ],
        ),
      ),
    );
  }
}
