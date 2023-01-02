import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:excuserapp/presentation/widgets/loading_widget.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  testWidgets('loading widget test', (tester) async {
    await tester.pumpWidget(
      const MediaQuery(data: MediaQueryData(), child: LoadingWidget()),
    );

    final shimmer = find.byType(Shimmer);
    expect(shimmer, findsNWidgets(2));
    expect(find.byType(LoadingWidget), findsOneWidget);
  });
}
