import 'package:dune/schema/collection.dart';
import 'package:dune/schema/folder.dart';
import 'package:dune/schema/info.dart';
import 'package:dune/widgets/collection/collection_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'collection_controller.dart';

class MainCollectionController extends GetxController {
  final collections = <Widget>[].obs;

  @override
  onInit() {
    super.onInit();
    var collectionMap = GetStorage().read(COLLECTIONS);
    Collection? collection = Collection.fromMap(collectionMap);
    initCollection(collection);
  }

  static MainCollectionController get to => Get.find();

  void initCollection(Collection? collection) {
    CollectionController controller =
        CollectionController(collection: collection);
    collection!.item!.forEach((element) {
      if (element is Folder) {
        controller.addFolder(
            parentController: controller, workingFolder: element);
      } else {
        controller.addRequest(
            parentController: controller, workingItem: element);
      }
    });
    collections.add(ChangeNotifierProvider.value(
      value: controller,
      child: FolderLine(
        position: collections.length,
        parentController: this,
      ),
    ));
  }

  void addCollection() {
    CollectionController controller = CollectionController(
        collection: Collection(info: Info(name: 'Random name')));
    collections.add(ChangeNotifierProvider.value(
      value: controller,
      child: FolderLine(
        position: collections.length,
        parentController: MainCollectionController.to,
      ),
    ));
  }

  void reorder(int oldIndex, int newIndex) {
    var oldItem = collections[oldIndex];
    collections[oldIndex] = collections[newIndex];
    collections[newIndex] = oldItem;
  }
}
