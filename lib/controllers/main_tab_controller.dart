import 'package:dune/controllers/request_controller.dart';
import 'package:dune/controllers/url_controller.dart';
import 'package:dune/models/environment.dart';
import 'package:dune/schema/item.dart';
import 'package:dune/widgets/environment/env_container.dart';
import 'package:dune/widgets/request_container/request_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'env_controller.dart';

class Page {
  String get name => "";
  String get method => "";

  int getOpenPosition(dynamic pages) {
    return pages.indexWhere((page) => page.name == this.name);
  }
}

class RequestPage extends Page {
  late RequestController responseController;
  late UrlController urlController;
  late Widget page;

  RequestPage(Item? data, {controller}) {
    if (controller == null) {
      urlController = UrlController(data);
      responseController = RequestController(urlController, data);
    } else {
      urlController = controller.urlController;
      responseController = controller;
    }
    page = ChangeNotifierProvider.value(
      value: urlController,
      child: ChangeNotifierProvider.value(
          value: responseController, child: RequestContainer()),
    );
  }

  @override
  String get name => urlController.nameInputController.text;

  @override
  String get method => urlController.methodDropDownController.value!['name'];
}

class EnvironmentPage extends Page {
  late EnvController envController;
  late Widget page;

  EnvironmentPage(Environment? data) {
    envController = EnvController(data);
    page = ChangeNotifierProvider.value(
        value: envController, child: EnvironmentContainer());
  }

  @override
  String get name => envController.environment.name;

  @override
  String get method => "ENV";
}

class MainTabController extends GetxController {
  final pages = [].obs;
  final currentPage = 0.obs;

  final PageController pageController = PageController();

  MainTabController() {
    addRequestPage(null);
  }

  static MainTabController get to => Get.find();

  void checkOpenAndAdd(Page page) {
    var position = page.getOpenPosition(pages);
    if (position == -1) {
      pages.add(page);
      activateLastPage();
    } else {
      changePage(position);
    }
  }

  void activateLastPage() {
    if (pageController.hasClients) {
      pageController.jumpToPage(pages.length - 1);
    }
    currentPage.value = pages.length - 1;
  }

  void addRequestPage(var data, {controller}) {
    RequestPage page = RequestPage(data, controller: controller);
    checkOpenAndAdd(page);
  }

  void addEnvPage(Environment data) {
    EnvironmentPage page = EnvironmentPage(data);
    checkOpenAndAdd(page);
  }

  void removePage(int position) {
    pages.removeAt(position);
    if (currentPage.value == position) {
      currentPage.value = pages.length - 1;
      pageController.jumpToPage(pages.length - 1);
    } else if (currentPage.value == pages.length) {
      currentPage.value = pages.length - 1;
    }
  }

  void changePage(int position) {
    pageController.jumpToPage(position);
    currentPage.value = position;
    update();
  }
}
