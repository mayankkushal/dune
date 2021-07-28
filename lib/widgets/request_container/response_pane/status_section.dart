import 'package:dune/controllers/response_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusSection extends StatelessWidget {
  const StatusSection({Key? key}) : super(key: key);

  String getSize(int length) {
    return (length / 1024).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final response = context.select((ResponseController r) => r.response);
    return Flexible(
      flex: 9,
      fit: FlexFit.tight,
      child: ClipRect(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(7)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: (response != null)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(
                            "Status: ${response.statusCode} ${response.statusMessage}"),
                        Text("Time Elapsed: ${response.responseTime}ms"),
                        Text(
                            "Size: ${response.contentSize().toStringAsFixed(2)}KB")
                      ])
                : Text('Response'),
          ),
        ),
      ),
    );
  }
}
