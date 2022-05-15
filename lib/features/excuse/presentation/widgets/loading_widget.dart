import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 40.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.grey[300]!,
            child: Container(
              color: Colors.black.withAlpha(100),
              width: 220.0,
              height: 16.0,
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.grey[300]!,
            child: Container(
              color: Colors.black.withAlpha(100),
              width: 150.0,
              height: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
