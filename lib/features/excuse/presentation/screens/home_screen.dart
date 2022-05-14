import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../locator.dart';
import '../../data/datasources/local/database.dart';
import '../cubit/excuse_cubit.dart';
import '../widgets/excuse_by_category_widget.dart';
import '../widgets/random_excuse_widget.dart';

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
                    .pushNamed('/dbViewer', arguments: locator<ExcuseDatabase>);
              },
              icon: const Icon(Icons.storage_rounded)),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => locator<ExcuseCubit>(),
            child: Column(
              children: const [
                RandomExcuseWidget(),
                ExcuseByCategoryWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
