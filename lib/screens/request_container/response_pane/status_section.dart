import 'package:flutter/material.dart';
import 'package:postwoman/controllers/response_controller.dart';
import 'package:provider/provider.dart';

class StatusSection extends StatelessWidget {
  const StatusSection({Key? key}) : super(key: key);

  String getSize(int length) {
    return (length / 1024).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    ReponseController responseController =
        Provider.of<ReponseController>(context);
    return Flexible(
      flex: 9,
      fit: FlexFit.tight,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(7)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: (responseController.response != null)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text(
                          "Status: ${responseController.response!.statusCode} ${responseController.response!.statusMessage}"),
                      Text(
                          "Time Elapsed: ${responseController.response!.stopwatch.elapsed.inMilliseconds}ms"),
                      Text(
                          "Size: ${responseController.response!.contentSize().toStringAsFixed(2)}KB")
                    ])
              : Text('Response'),
        ),
      ),
    );
  }
}
