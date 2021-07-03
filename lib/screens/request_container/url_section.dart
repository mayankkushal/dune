import 'package:flutter/material.dart';
import 'package:postwoman/controllers/response_controller.dart';
import 'package:postwoman/theme.dart';
import 'package:postwoman/widgets/dropdown.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class UrlSection extends StatelessWidget {
  const UrlSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReponseController responseController =
        Provider.of<ReponseController>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownFormField<Map<String, dynamic>>(
              controller: responseController.methodDropDownController,
              onEmptyActionPressed: () async {},
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              onSaved: (dynamic str) {},
              dropdownHeight: 300,
              onChanged: (dynamic str) {},
              validator: (dynamic str) {},
              dropdownColor: AppColors.background,
              displayItemFn: (dynamic item) => Text(
                item['name'],
              ),
              findFn: (dynamic str) async => METHODS,
              filterFn: (dynamic item, str) =>
                  item['name'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
              dropdownItemFn: (dynamic item, position, focused,
                      dynamic lastSelectedItem, onTap) =>
                  ListTile(
                title: Text(item['name']),
                tileColor: focused ? Colors.red : Colors.transparent,
                onTap: onTap,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 8,
          child: TextField(
            controller: responseController.urlInputController,
          ),
        ),
        ElevatedButton(
            onPressed: responseController.fetchRequest, child: Text("Submit"))
      ],
    );
  }
}
