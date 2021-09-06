import 'package:dune/controllers/main_tab_controller.dart';
import 'package:dune/controllers/request_controller.dart';
import 'package:dune/controllers/url_controller.dart';
import 'package:dune/theme.dart';
import 'package:dune/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../custom_code_field.dart';

class UrlSection extends StatelessWidget {
  const UrlSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final urlController = context.watch<UrlController>();
    final requestController = context.read<RequestController>();
    return Column(
      children: [
        TextField(
          controller: urlController.nameInputController,
          onChanged: (value) {
            requestController.updateName(value);
            MainTabController.to.update();
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownFormField<Map<String, dynamic>>(
                  controller: urlController.methodDropDownController,
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
              flex: 7,
              child: CustomCodeField(
                  controller: urlController.urlInputController,
                  showLineNumber: false,
                  inputDecoration: InputDecoration(labelText: 'URL'),
                  background: AppColors.background),
            ),
            ElevatedButton(
                onPressed: requestController.fetchRequest,
                child: Text("Submit"))
          ],
        ),
      ],
    );
  }
}
