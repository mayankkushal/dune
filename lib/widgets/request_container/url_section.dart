import 'package:dune/controllers/main_tab_controller.dart';
import 'package:dune/controllers/response_controller.dart';
import 'package:dune/theme.dart';
import 'package:dune/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class UrlSection extends StatelessWidget {
  const UrlSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResponseController responseController =
        Provider.of<ResponseController>(context);
    return Column(
      children: [
        TextField(
          controller: responseController.nameInputController,
          onChanged: (_) => MainTabController.to.update(),
        ),
        Row(
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
                  onChanged: (dynamic str) {
                    MainTabController.to.update();
                  },
                  validator: (dynamic str) {},
                  dropdownColor: AppColors.background,
                  displayItemFn: (dynamic item) => Text(
                    item['name'],
                  ),
                  findFn: (dynamic str) async => METHODS,
                  filterFn: (dynamic item, str) =>
                      item['name'].toLowerCase().indexOf(str.toLowerCase()) >=
                      0,
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
                onPressed: responseController.fetchRequest,
                child: Text("Submit"))
          ],
        ),
      ],
    );
  }
}
