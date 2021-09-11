import 'package:dune/controllers/request_controller.dart';
import 'package:dune/controllers/url_controller.dart';
import 'package:dune/schema/collection.dart';
import 'package:dune/schema/folder.dart';
import 'package:dune/schema/item.dart';
import 'package:dune/widgets/collection/collection_section.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class CollectionController extends ChangeNotifier {
  Collection? collection;
  Folder? folder;
  List<dynamic> item = [];

  CollectionController({this.collection, this.folder});

  bool get isCollection => collection != null;

  String get name => collection != null
      ? collection!.info!.name as String
      : folder!.name as String;

  void addItem(dynamic item) {
    if (isCollection) {
      if (collection!.item != null)
        collection!.item!.add(item);
      else
        collection!.item = [item];
    } else {
      if (folder!.item != null)
        folder!.item!.add(item);
      else
        folder!.item = [item];
    }
  }

  void addFolder({parentController, Folder? workingFolder, bool init = false}) {
    if (workingFolder == null) {
      workingFolder = Folder(name: "Folder test ${item.length}");
      addItem(workingFolder);
    }
    CollectionController controller =
        CollectionController(folder: workingFolder);
    var key = UniqueKey();

    workingFolder.item!.forEach((element) {
      if (element is Folder) {
        controller.addFolder(
            parentController: controller, workingFolder: element);
      } else {
        controller.addRequest(
            parentController: controller, workingItem: element);
      }
    });

    item.add({
      "identifier": key,
      "controller": controller,
      "widget": ChangeNotifierProvider.value(
        value: controller,
        child: FolderLine(
          key: key,
          position: item.length,
          identifier: key,
          parentController: parentController,
        ),
      )
    });
    notifyListeners();
  }

  void addRequest({parentController, Item? workingItem, bool init = false}) {
    if (workingItem == null) {
      workingItem = Item(name: "Request test name");
      addItem(workingItem);
    }

    UrlController urlController = UrlController(workingItem);
    RequestController requestController =
        RequestController(urlController, workingItem);

    var key = UniqueKey();
    item.add({
      "identifier": key,
      "controller": requestController,
      "widget": ChangeNotifierProvider.value(
        value: requestController,
        child: RequestLine(
          key: key,
          identifier: key,
          parentController: parentController,
        ),
      )
    });
  }

  void saveCollection() async {
    var storage = GetStorage();
    await storage.write(COLLECTIONS, collection!.toMap());
  }

  void deleteFolder(var identifier) {
    item.removeWhere((i) => i['identifier'] == identifier);
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    var oldItem = item[oldIndex];
    item[oldIndex] = item[newIndex];
    item[newIndex] = oldItem;
  }
}
