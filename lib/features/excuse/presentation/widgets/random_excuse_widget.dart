import 'package:excuserapp/features/excuse/presentation/widgets/loading_widget.dart';

import '../../domain/entities/excuse.dart';
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
                      child: BlocBuilder<RandomExcuseCubit, RandomExcuseState>(
                        builder: (context, state) {
                          if (state is RandomExcuseInitial) {
                            context.read<RandomExcuseCubit>().getRandomExcuse();
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
                              style: TextStyle(fontFamily: 'Montserrat'),
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
                      await Clipboard.setData(ClipboardData(text: _excuse));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Copied to clipboard'),
                      ));
                      print(_excuse);
                    },
                    icon: const Icon(Icons.copy),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                context.read<RandomExcuseCubit>().getRandomExcuse();
              },
              child: const Text('Get another one'),
            ),
          ],
        ),
      ),
    );
  }
}
