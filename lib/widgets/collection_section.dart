import 'package:dune/controllers/main_tab_controller.dart';
import 'package:dune/controllers/request_controller.dart';
import 'package:dune/controllers/url_controller.dart';
import 'package:dune/schema/collection.dart';
import 'package:dune/schema/folder.dart' as folderItem;
import 'package:dune/schema/info.dart';
import 'package:dune/schema/item.dart';
import 'package:dune/widgets/side_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MainCollectionController extends GetxController {
  final collections = <Widget>[].obs;

  @override
  onInit() {
    super.onInit();
    // var storageHistrory = GetStorage().read('history');
    // if (storageHistrory != null) {
    //   history.value = GetStorage().read('history');
    // }
  }

  static MainCollectionController get to => Get.find();

  void addCollection() {
    CollectionController controller = CollectionController(
        collection: Collection(info: Info(name: 'Random name')));
    collections.add(ChangeNotifierProvider.value(
      value: controller,
      child: Folder(
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

class CollectionController extends ChangeNotifier {
  Collection? collection;
  folderItem.Folder? folder;
  List<dynamic> item = [];

  CollectionController({this.collection, this.folder});

  String get name => collection != null
      ? collection!.info!.name as String
      : folder!.name as String;

  void addFolder({parentController}) {
    CollectionController controller = CollectionController(
        folder: folderItem.Folder(name: "Folder test ${item.length}"));
    var key = UniqueKey();
    item.add({
      "identifier": key,
      "widget": ChangeNotifierProvider.value(
        value: controller,
        child: Folder(
          key: key,
          position: item.length,
          identifier: key,
          parentController: parentController,
        ),
      )
    });
    notifyListeners();
  }

  void addRequest({parentController}) {
    print('add request');
    var data = Item(name: "Request test name");
    UrlController urlController = UrlController(data);
    RequestController responseController =
        RequestController(urlController, data);
    var key = UniqueKey();
    item.add({
      "identifier": key,
      "widget": ChangeNotifierProvider.value(
        value: responseController,
        child: Request(
          key: key,
          identifier: key,
          parentController: parentController,
        ),
      )
    });
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

class CollectionSection extends StatelessWidget {
  const CollectionSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainCollectionController mainCollectionController =
        MainCollectionController.to;

    return Column(
      children: [
        SidebarTitle("Collection"),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8.0)),
          child: Row(
            children: [
              IconButton(
                  onPressed: mainCollectionController.addCollection,
                  icon: Icon(Icons.add))
            ],
          ),
        ),
        Expanded(
          child: Obx(
            () => ListView(
              children: [...mainCollectionController.collections.value],
            ),
          ),
        )
      ],
    );
  }
}

class Request extends StatelessWidget {
  final identifier;
  final parentController;
  const Request(
      {Key? key, required this.identifier, required this.parentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final requestController = context.watch<RequestController>();
    MainTabController mainTabController = MainTabController.to;
    return InkWell(
      onTap: () {
        mainTabController.addRequestPage(null, controller: requestController);
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.arrow_right,
                  color: Colors.transparent,
                ),
                Text(requestController.urlController.nameInputController.text),
              ],
            ),
            PopupMenuButton(
              child: Icon(
                Icons.more_horiz,
                size: 15,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      onTap: () => parentController.deleteFolder(identifier),
                      child: Text("Delete"))
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Folder extends StatefulWidget {
  final int position;
  final identifier;
  final parentController;
  Folder(
      {Key? key,
      required this.position,
      required this.parentController,
      this.identifier})
      : super(key: key);

  @override
  State<Folder> createState() => _FolderState();
}

class _FolderState extends State<Folder> with TickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  bool expanded = false;
  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 10));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.easeInOut,
    );
  }

  void expand() {
    expandController.forward();
    setState(() {
      expanded = true;
    });
  }

  void toggleExpand() {
    if (expanded) {
      expandController.reverse();
      setState(() {
        expanded = false;
      });
    } else {
      expand();
    }
  }

  @override
  Widget build(BuildContext context) {
    final collectionController = context.watch<CollectionController>();

    return Column(
      children: [
        InkWell(
          // onTap: toggleExpand,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: toggleExpand,
                    splashRadius: 0.1,
                    icon: Icon(
                        expanded ? Icons.arrow_drop_down : Icons.arrow_right),
                  ),
                  Text(collectionController.name),
                ],
              ),
              PopupMenuButton(
                child: Icon(
                  Icons.more_horiz,
                  size: 15,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        onTap: () {
                          collectionController.addRequest(
                              parentController: collectionController);
                          expand();
                        },
                        child: Text("Add Request")),
                    PopupMenuItem(
                        onTap: () {
                          collectionController.addFolder(
                              parentController: collectionController);
                          expand();
                        },
                        child: Text("Add Folder")),
                    PopupMenuItem(
                        onTap: () => widget.parentController
                            .deleteFolder(widget.identifier),
                        child: Text("Delete"))
                  ];
                },
              ),
            ],
          ),
        ),
        SizeTransition(
          sizeFactor: animation,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: collectionController.item.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: collectionController.item.length,
                    itemBuilder: (context, i) =>
                        collectionController.item[i]['widget'],
                  )
                : Container(child: Text("This folder is empty")),
          ),
        )
      ],
    );
  }
}
