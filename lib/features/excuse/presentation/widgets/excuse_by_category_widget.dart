import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/excuse.dart';
import '../cubit/randomcategoryexcuse/cubit/random_category_excuse_cubit.dart';
import 'loading_widget.dart';

class ExcuseByCategoryWidget extends StatefulWidget {
  const ExcuseByCategoryWidget({Key? key}) : super(key: key);

  @override
  State<ExcuseByCategoryWidget> createState() => _ExcuseByCategoryWidgetState();
}

class _ExcuseByCategoryWidgetState extends State<ExcuseByCategoryWidget> {
  var _excuseCategory = 'family';
  var _excuse = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 200,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: BlocBuilder<RandomCategoryExcuseCubit,
                        RandomCategoryExcuseState>(
                      builder: (context, state) {
                        if (state is RandomCategoryExcuseInitial) {
                          context
                              .read<RandomCategoryExcuseCubit>()
                              .getRandomExcuseByCategory(_excuseCategory);
                        }
                        if (state is RandomCategoryExcuseLoading) {
                          return const LoadingWidget();
                        } else if (state is RandomCategoryExcuseError) {
                          return const Center(
                              child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          ));
                        } else if (state is RandomCategoryExcuseLoaded) {
                          _excuse = state.excuse.excuse;
                          return Text(
                            state.excuse.excuse,
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
            Wrap(
              children: [
                ChoiceChip(
                  label: const Text('family'),
                  selected: _excuseCategory == 'family',
                  selectedColor: Colors.purple,
                  onSelected: (bool isSelected) {
                    setState(() {
                      _excuseCategory = 'family';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('office'),
                  selected: _excuseCategory == 'office',
                  selectedColor: Colors.purple,
                  onSelected: (bool isSelected) {
                    setState(() {
                      _excuseCategory = 'office';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('children'),
                  selected: _excuseCategory == 'children',
                  selectedColor: Colors.purple,
                  onSelected: (bool isSelected) {
                    setState(() {
                      _excuseCategory = 'children';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('college'),
                  selected: _excuseCategory == 'college',
                  selectedColor: Colors.purple,
                  onSelected: (bool isSelected) {
                    setState(() {
                      _excuseCategory = 'college';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('party'),
                  selected: _excuseCategory == 'party',
                  onSelected: (bool isSelected) {
                    setState(() {
                      _excuseCategory = 'party';
                    });
                  },
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                context
                    .read<RandomCategoryExcuseCubit>()
                    .getRandomExcuseByCategory(_excuseCategory);
              },
              child: const Text('Get another one'),
            ),
          ],
        ),
      ),
    );
  }
}
