import 'package:flutter/material.dart';

import 'features/excuse/data/datasources/local/database.dart';
import 'features/excuse/presentation/router.dart';
import 'features/excuse/presentation/widgets/excuse_by_category_widget.dart';
import 'features/excuse/presentation/widgets/random_excuse_widget.dart';

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
