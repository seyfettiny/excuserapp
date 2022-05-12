import 'package:dio/dio.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:excuserapp/features/excuse/data/datasources/local/database.dart';
import 'package:excuserapp/features/excuse/data/datasources/remote/excuser_api.dart';
import 'package:excuserapp/features/excuse/data/models/excuse_model.dart';

import 'features/excuse/presentation/router.dart';

late ExcuseDatabase instance;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  instance = ExcuseDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      onGenerateRoute: MyRouter.generateRoute,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/dbViewer', arguments: instance);
              },
              icon: const Icon(Icons.storage_rounded)),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: const [
            RandomExcuseWidget(),
            ExcuseByCategoryWidget(),
          ],
        ),
      ),
    );
  }
}

class ExcuseByCategoryWidget extends StatefulWidget {
  const ExcuseByCategoryWidget({Key? key}) : super(key: key);

  @override
  State<ExcuseByCategoryWidget> createState() => _ExcuseByCategoryWidgetState();
}

class _ExcuseByCategoryWidgetState extends State<ExcuseByCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

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
