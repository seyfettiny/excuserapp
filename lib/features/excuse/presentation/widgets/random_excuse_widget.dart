import '../../data/datasources/local/database.dart';
import '../../domain/entities/excuse.dart';
import '../cubit/excuse_cubit.dart';
import '../../../../locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RandomExcuseWidget extends StatefulWidget {
  const RandomExcuseWidget({Key? key}) : super(key: key);

  @override
  State<RandomExcuseWidget> createState() => _RandomExcuseWidgetState();
}

class _RandomExcuseWidgetState extends State<RandomExcuseWidget> {
  @override
  void initState() {
    super.initState();
  }

  Excuse _excuse = Excuse(id: 1, excuse: '', category: '');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Random Excuse'),
        Card(
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
                                return const Center(
                                    child: CircularProgressIndicator());
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
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await Clipboard.setData(
                              ClipboardData(text: _excuse.excuse.toString()));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Copied to clipboard'),
                          ));
                        },
                        icon: const Icon(Icons.copy),
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        context.read<ExcuseCubit>().getRandomExcuse();
                      },
                      child: const Text('Get another one'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        locator<ExcuseDatabase>()
                            .insertExcuse(
                              _excuse.id,
                              _excuse.excuse,
                              _excuse.category,
                            )
                            .then((value) => print('inserted'))
                            .onError((error, stackTrace) => print(error));
                      },
                      child: const Text('Save this'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: 300,
            height: 150,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                OutlinedButton(
                  onPressed: () {
                    var selectable = locator<ExcuseDatabase>().getRandomExcuse()
                      ..getSingle().then((value) {
                        setState(() {
                          _excuse = Excuse(
                            id: value.id,
                            excuse: value.excuse!,
                            category: value.category!,
                          );
                        });
                      });
                  },
                  child: const Text('Get random saved'),
                ),
                Text(_excuse.excuse),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
