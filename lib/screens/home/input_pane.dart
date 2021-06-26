import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:postwoman/screens/home/home.dart';
import 'package:provider/provider.dart';

class InputPane extends HookWidget {
  final GlobalKey<FormState> _parameterFormKey;

  const InputPane({
    Key? key,
    required GlobalKey<FormState> parameterFormKey,
  })  : _parameterFormKey = parameterFormKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    ParameterInputController parameterInputController =
        Provider.of<ParameterInputController>(context);

    useEffect(() {
      parameterInputController.addParameter(ParameterInputType.query, count: 4);
    }, []);
    return Form(
      key: _parameterFormKey,
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
                    padding: const EdgeInsets.fromLTRB(8.0, 1, 8.0, 1),
                    child: Row(
                      children: [Text('Parameters')],
                    ),
                  ),
                ),
              ),
              Container(
                child: Flexible(
                  flex: 9,
                  child: ListView(
                    controller: scrollController,
                    children: [...parameterInputController.queryParamMap.keys],
                  ),
                ),
              ),
              Flexible(
                child: IconButton(
                  onPressed: () {
                    parameterInputController
                        .addParameter(ParameterInputType.query);
                    Timer(
                        Duration(milliseconds: 125),
                        () => scrollController
                            .jumpTo(scrollController.position.maxScrollExtent));
                  },
                  icon: Icon(Icons.add),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
