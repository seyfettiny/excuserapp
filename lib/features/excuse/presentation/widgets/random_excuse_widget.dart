import '../../data/datasources/local/database.dart';
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

  String getFromDB = "";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExcuseCubit, ExcuseState>(builder: (context, state) {
      print(state.toString());
      if (state is ExcuseInitial) {
        context.read<ExcuseCubit>().getRandomExcuse();
      }
      if (state is ExcuseLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is ExcuseError) {
        print(state.error);
        return const Center(
            child: Icon(
          Icons.error_outline,
          color: Colors.red,
        ));
      } else if (state is ExcuseLoaded) {
        final excuse = state.excuse;
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
                              child: Text(
                                excuse.excuse.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(
                                  text: excuse.excuse.toString()));
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text('Get another one'),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            locator<ExcuseDatabase>()
                                .insertExcuse(
                                  excuse.id,
                                  excuse.excuse,
                                  excuse.category,
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
                        var selectable =
                            locator<ExcuseDatabase>().getRandomExcuse()
                              ..getSingle().then((value) {
                                setState(() {
                                  print('value: $value');
                                  getFromDB = value.excuse.toString();
                                });
                              });
                      },
                      child: const Text('Get random saved'),
                    ),
                    Text(getFromDB),
                  ],
                ),
              ),
            ),
          ],
        );
      } else {
        return const Center(child: Icon(Icons.error));
      }
    });
  }
}
