import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:glass/glass.dart';

import '../../../theme.dart';

class ResponseLoader extends StatelessWidget {
  const ResponseLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitChasingDots(
              color: AppColors.yellow,
              size: 50.0,
            ),
            Text("Fetching Response")
          ],
        ),
      ).asGlass(clipBorderRadius: BorderRadius.circular(10)),
    );
  }
}
