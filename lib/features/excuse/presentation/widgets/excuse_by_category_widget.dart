import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/remote/excuser_api.dart';
import '../../data/models/excuse_model.dart';

class ExcuseByCategoryWidget extends StatefulWidget {
  const ExcuseByCategoryWidget({Key? key}) : super(key: key);

  @override
  State<ExcuseByCategoryWidget> createState() => _ExcuseByCategoryWidgetState();
}

class _ExcuseByCategoryWidgetState extends State<ExcuseByCategoryWidget> {
  late final ExcuserAPI api;
  var _excuseCategory = 'family';
  @override
  void initState() {
    super.initState();
    //TODO: refactor this
    api = ExcuserAPI(Dio());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: FutureBuilder(
        future: api.getRandomExcuseByCategory(_excuseCategory),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ExcuseModel excuse = snapshot.data as ExcuseModel;

            return Column(
              children: [
                const Text('Excuse by Category'),
                Card(
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
                        Expanded(
                          child: Center(child: Text(excuse.excuse)),
                        ),
                        Wrap(
                          children: [
                            ChoiceChip(
                              label: const Text('family'),
                              selected: _excuseCategory == 'family',
                              onSelected: (bool isSelected) {
                                _excuseCategory = 'family';
                              },
                            ),
                            ChoiceChip(
                              label: const Text('office'),
                              selected: _excuseCategory == 'office',
                              onSelected: (bool isSelected) {
                                _excuseCategory = 'office';
                              },
                            ),
                            ChoiceChip(
                              label: const Text('children'),
                              selected: _excuseCategory == 'children',
                              onSelected: (bool isSelected) {
                                _excuseCategory = 'children';
                              },
                            ),
                            ChoiceChip(
                              label: const Text('college'),
                              selected: _excuseCategory == 'college',
                              onSelected: (bool isSelected) {
                                _excuseCategory = 'college';
                              },
                            ),
                            ChoiceChip(
                              label: const Text('party'),
                              selected: _excuseCategory == 'party',
                              onSelected: (bool isSelected) {
                                _excuseCategory = 'party';
                              },
                            ),
                          ],
                        ),
                        TextButton(
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
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
