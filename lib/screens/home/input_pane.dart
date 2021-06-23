import 'package:flutter/material.dart';

class InputPane extends StatelessWidget {
  const InputPane({
    Key? key,
    required GlobalKey<FormState> parameterFormKey,
    required this.parameterList,
    required this.onPressed,
  })  : _parameterFormKey = parameterFormKey,
        super(key: key);

  final GlobalKey<FormState> _parameterFormKey;
  final ValueNotifier<List> parameterList;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _parameterFormKey,
      child: Flexible(
        flex: 4,
        fit: FlexFit.tight,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(7)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [Text('Parameters')],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Flexible(
                    flex: 9,
                    child: Column(
                      children: [...parameterList.value],
                    ),
                  ),
                ),
                Flexible(
                  child: IconButton(
                    onPressed: onPressed,
                    icon: Icon(Icons.add),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
