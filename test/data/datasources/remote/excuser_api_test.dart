import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:excuserapp/data/datasources/remote/excuser_api.dart';
import 'package:excuserapp/data/models/excuse_model.dart';
import 'package:excuserapp/util/random_num.dart';

void main() {
  late ExcuserAPI excuserAPI;
  late HttpServer mockServer;
  late SupabaseClient client;
  late String apiKey;
  late String locale;

  final int randomNum = RandomNum.random(1, 20);
  final Set<String> listeners = {};

  const int excuseIdRequest = 2;
  const String excuseCategoryRequest = 'school';
  const customApiKey = 'customApiKey';
  const customHeaders = {'customfield': 'customvalue', 'apikey': customApiKey};
  WebSocket? webSocket;
  bool hasListener = false;
  StreamSubscription<dynamic>? listener;

  final List dummyJsonList =
      jsonDecode(File('test/helpers/dummy_excuses.json').readAsStringSync());

  /// `testFilter` is used to test incoming realtime filter. The value should match the realtime filter set by the library.
  Future<void> handleRequests(
    HttpServer server, {
    String? expectedFilter,
  }) async {
    await for (final HttpRequest request in server) {
      final headers = request.headers;
      if (headers.value('X-Client-Info') != 'supabase-flutter/0.0.0') {
        throw 'Proper header not set';
      }
      final url = request.uri.toString();
      print(url);
      if (url.startsWith("/rest")) {
        final foundApiKey = headers.value('apikey');
        expect(foundApiKey, apiKey);
        if (foundApiKey == customApiKey) {
          expect(headers.value('customfield'), 'customvalue');
        }

        // Check that rest api contains the correct filter in the URL
        if (expectedFilter != null) {
          expect(url.contains(expectedFilter), isTrue);
        }
      }
      if (url == '/rest/v1/$locale?select=%2A&id=eq.$randomNum') {
        final jsonString = jsonEncode(dummyJsonList
            .where((element) => element['id'] == randomNum)
            .toList());
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(jsonString)
          ..close();
      } else if (url == '/rest/v1/$locale?select=%2A&id=eq.$excuseIdRequest') {
        final jsonString = jsonEncode(dummyJsonList
            .where((element) => element['id'] == excuseIdRequest)
            .toList());
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(jsonString)
          ..close();
      } else if (url == '/rest/v1/$locale?select=*' ||
          url == '/rest/v1/rpc/$locale?select=*') {
        final jsonString = dummyJsonList.toString();
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(jsonString)
          ..close();
      } else if (url ==
          '/rest/v1/$locale?select=%2A&category=eq.$excuseCategoryRequest') {
        final jsonString = jsonEncode(dummyJsonList
            .where((element) => element['category'] == excuseCategoryRequest)
            .toList());
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(jsonString)
          ..close();
      } else if (url == '/rest/v1/$locale?select=%2A&order=id.desc.nullslast') {
        final jsonString = jsonEncode([
          {'id': 2, 'excuse': 'excuse 2', 'category': "family"},
          {'id': 1, 'excuse': 'excuse 1', 'category': "family"},
        ]);
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(jsonString)
          ..close();
      } else if (url ==
          '/rest/v1/$locale?select=*&order=id.desc.nullslast&limit=2') {
        final jsonString = jsonEncode([
          {'id': 2, 'excuse': 'excuse 2', 'category': "family"},
          {'id': 1, 'excuse': 'excuse 1', 'category': "family"},
        ]);
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(jsonString)
          ..close();
      } else if (url.contains('rest')) {
        // Just return an empty string as dummy data if any other rest request
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write('[]')
          ..close();
      } else if (url.contains('realtime')) {
        webSocket = await WebSocketTransformer.upgrade(request);
        if (hasListener) {
          return;
        }
        hasListener = true;
        listener = webSocket!.listen((request) async {
          /// `filter` might be there or not depending on whether is a filter set
          /// to the realtime subscription, so include the filter if the request
          /// includes a filter.
          final requestJson = jsonDecode(request);
          final topic = requestJson['topic'];
          final ref = requestJson["ref"];

          if (requestJson["event"] == "phx_leave") {
            listeners.remove(topic);
            return;
          }
          if (listeners.contains(topic)) {
            return;
          }
          listeners.add(topic);

          final String? realtimeFilter = requestJson['payload']['config']
                  ['postgres_changes']
              .first['filter'];

          if (expectedFilter != null) {
            expect(realtimeFilter, expectedFilter);
          }

          final replyString = jsonEncode({
            'event': 'phx_reply',
            'payload': {
              'response': {
                'postgres_changes': [
                  {
                    'id': 77086988,
                    'event': 'INSERT',
                    'schema': 'public',
                    'table': locale,
                    if (realtimeFilter != null) 'filter': realtimeFilter,
                  },
                  {
                    'id': 25993878,
                    'event': 'UPDATE',
                    'schema': 'public',
                    'table': locale,
                    if (realtimeFilter != null) 'filter': realtimeFilter,
                  },
                  {
                    'id': 48673474,
                    'event': 'DELETE',
                    'schema': 'public',
                    'table': locale,
                    if (realtimeFilter != null) 'filter': realtimeFilter,
                  }
                ]
              },
              'status': 'ok'
            },
            'ref': ref,
            'topic': topic
          });
          webSocket!.add(replyString);

          // Send an insert event
          await Future.delayed(const Duration(milliseconds: 300));
          final insertString = jsonEncode({
            'topic': topic,
            'event': 'postgres_changes',
            'ref': null,
            'payload': {
              'ids': [77086988],
              'data': {
                'commit_timestamp': '2021-08-01T08:00:20Z',
                'record': {'id': 3, 'excuse': 'excuse 3', 'category': "family"},
                'schema': 'public',
                'table': locale,
                'type': 'INSERT',
                if (realtimeFilter != null) 'filter': realtimeFilter,
                'columns': [
                  {
                    'name': 'id',
                    'type': 'int4',
                    'type_modifier': 4294967295,
                  },
                  {
                    'name': 'excuse',
                    'type': 'text',
                    'type_modifier': 4294967295,
                  },
                  {
                    'name': 'category',
                    'type': 'text',
                    'type_modifier': 4294967295,
                  },
                ],
              },
            },
          });
          webSocket!.add(insertString);

          // Send an update event for id = 2
          await Future.delayed(const Duration(milliseconds: 10));
          final updateString = jsonEncode({
            'topic': topic,
            'ref': null,
            'event': 'postgres_changes',
            'payload': {
              'ids': [25993878],
              'data': {
                'columns': [
                  {'name': 'id', 'type': 'int4', 'type_modifier': 4294967295},
                  {
                    'name': 'excuse',
                    'type': 'text',
                    'type_modifier': 4294967295
                  },
                  {
                    'name': 'category',
                    'type': 'text',
                    'type_modifier': 4294967295
                  },
                ],
                'commit_timestamp': '2021-08-01T08:00:30Z',
                'errors': null,
                'old_record': {'id': 2},
                'record': {
                  'id': 2,
                  'excuse': 'excuse 2 updated',
                  'category': 'family'
                },
                'schema': 'public',
                'table': locale,
                'type': 'UPDATE',
                if (realtimeFilter != null) 'filter': realtimeFilter,
              },
            },
          });
          webSocket!.add(updateString);

          // Send delete event for id=2
          await Future.delayed(const Duration(milliseconds: 10));
          final deleteString = jsonEncode({
            'ref': null,
            'topic': topic,
            'event': 'postgres_changes',
            'payload': {
              'data': {
                'columns': [
                  {'name': 'id', 'type': 'int4', 'type_modifier': 4294967295},
                  {
                    'name': 'excuse',
                    'type': 'text',
                    'type_modifier': 4294967295
                  },
                  {
                    'name': 'category',
                    'type': 'text',
                    'type_modifier': 4294967295
                  },
                ],
                'commit_timestamp': '2022-09-14T02:12:52Z',
                'errors': null,
                'old_record': {'id': 2},
                'schema': 'public',
                'table': locale,
                'type': 'DELETE',
                if (realtimeFilter != null) 'filter': realtimeFilter,
              },
              'ids': [48673474]
            },
          });
          webSocket!.add(deleteString);
        });
      } else {
        request.response
          ..statusCode = HttpStatus.ok
          ..close();
      }
    }
  }

  setUp(() async {
    //setupLocator();
    apiKey = 'supabaseKey';
    locale = 'en';
    //GetIt.instance.registerSingleton<String>(Platform.localeName);
    mockServer = await HttpServer.bind('localhost', 0);

    handleRequests(mockServer);

    client = SupabaseClient(
      'http://${mockServer.address.host}:${mockServer.port}',
      apiKey,
      headers: {
        'X-Client-Info': 'supabase-flutter/0.0.0',
      },
    );

    excuserAPI = ExcuserAPI(client, locale);
  });

  tearDown(() async {
    listener?.cancel();
    listeners.clear();

    // Wait for the realtime updates to come through
    await Future.delayed(const Duration(milliseconds: 100));

    await webSocket?.close();
    await mockServer.close();
  });

  group('basic test', () {
    test('should return excuse', () async {
      final data = await excuserAPI.getExcuseById(excuseIdRequest);

      expect(data, isA<ExcuseModel>());
    });

    test('should get excuse by correct ID', () async {
      final data = await excuserAPI.getExcuseById(excuseIdRequest);

      expect(data.id, excuseIdRequest);
    });

    test('should get random excuse', () async {
      final data = await excuserAPI.getRandomExcuse(randomNum);

      expect(data, isA<ExcuseModel>());
    });

    test('should get list of ExcuseModel', () async {
      final data =
          await excuserAPI.getExcuseListByCategory(excuseCategoryRequest);

      expect(data, isA<List<ExcuseModel>>());
    });

    test('should get excuse list by given category', () async {
      final data =
          await excuserAPI.getExcuseListByCategory(excuseCategoryRequest);

      expect(
        data,
        everyElement(predicate<ExcuseModel>(
            (value) => value.category == excuseCategoryRequest)),
      );
    });

    test('should get random excuse by given category', () async {
      final List categoryList =
          await excuserAPI.getExcuseListByCategory(excuseCategoryRequest);
      final randomIndex = RandomNum.random(0, categoryList.length);
      final data = await excuserAPI.getRandomExcuseByCategory(
          excuseCategoryRequest, randomIndex);

      expect(data.category, excuseCategoryRequest);
    });
  });
}
