import 'package:dio/dio.dart';
import 'package:excuserapp/features/excuse/data/datasources/local/database.dart';
import 'package:excuserapp/features/excuse/data/datasources/remote/excuser_api.dart';
import 'package:excuserapp/features/excuse/domain/entities/excuse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ExcuserAPI api;

  late ExcuseDB instance = ExcuseDB();

  @override
  Widget build(BuildContext context) {
    api = ExcuserAPI(Dio());
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: FutureBuilder(
              future: api.getRandomExcuse(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Excuse excuse = snapshot.data as Excuse;
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const CircularProgressIndicator();
              }),
        ),
      ),
    );
  }
}
