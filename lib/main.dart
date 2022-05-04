import 'package:dio/dio.dart';
import 'package:excuserapp/features/excuse/data/datasources/local/database.dart';
import 'package:excuserapp/features/excuse/data/datasources/remote/excuser_api.dart';
import 'package:excuserapp/features/excuse/domain/entities/excuse.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late ExcuserAPI api;
  late ExcuseDB instance = ExcuseDB();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    api = ExcuserAPI(Dio());
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Center(
          child: FutureBuilder(
              future: api.getRandomExcuse(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Excuse excuse = snapshot.data as Excuse;
                  return Text(excuse.excuse.toString());
                }
                return const CircularProgressIndicator();
              }),
        ),
      ),
    );
  }
}
