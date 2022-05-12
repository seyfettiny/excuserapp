import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../main.dart';
import '../../data/datasources/remote/excuser_api.dart';
import '../../data/models/excuse_model.dart';

class RandomExcuseWidget extends StatefulWidget {
  const RandomExcuseWidget({Key? key}) : super(key: key);

  @override
  State<RandomExcuseWidget> createState() => _RandomExcuseWidgetState();
}

class _RandomExcuseWidgetState extends State<RandomExcuseWidget> {
  late final ExcuserAPI api;

  @override
  void initState() {
    super.initState();
    //TODO: refactor this
    api = ExcuserAPI(Dio());
  }

  String getFromDB = "";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api.getRandomExcuse(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ExcuseModel excuse = snapshot.data as ExcuseModel;

          return Column(
            children: [
              const Text('Random Excuse'),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  width: 300,
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
                      OutlinedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: const Text('Get another one'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          instance
                              .insertExcuse(
                                  excuse.id, excuse.excuse, excuse.category)
                              .then((value) => print('inserted'))
                              .onError((error, stackTrace) => print(error));
                        },
                        child: const Text('Save this'),
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
                          var selectable = instance.getRandomExcuse()
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
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
