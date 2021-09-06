import 'package:dune/controllers/collection_controller.dart';
import 'package:dune/controllers/main_collection_controller.dart';
import 'package:dune/controllers/main_tab_controller.dart';
import 'package:dune/controllers/request_controller.dart';
import 'package:dune/widgets/side_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

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

class RequestLine extends StatelessWidget {
  final identifier;
  final parentController;
  const RequestLine(
      {Key? key, required this.identifier, required this.parentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final requestController = context.watch<RequestController>();
    MainTabController mainTabController = MainTabController.to;
    return InkWell(
      onTap: () {
        mainTabController.addRequestPage(requestController.parsedResponse,
            controller: requestController);
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

class FolderLine extends StatefulWidget {
  final int position;
  final identifier;
  final parentController;
  FolderLine(
      {Key? key,
      required this.position,
      required this.parentController,
      this.identifier})
      : super(key: key);

  @override
  State<FolderLine> createState() => _FolderLineState();
}

class _FolderLineState extends State<FolderLine> with TickerProviderStateMixin {
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
                        child: Text("Delete")),
                    if (collectionController.isCollection)
                      PopupMenuItem(
                          onTap: () => collectionController.saveCollection(),
                          child: Text("Save")),
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
