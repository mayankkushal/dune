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

class RequestPage {
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

  String get name => urlController.nameInputController.text;
  String get method => urlController.methodDropDownController.value!['name'];
}

class EnvironmentPage {
  late EnvController envController;
  late Widget page;

  EnvironmentPage(Environment? data) {
    envController = EnvController(data);
    page = ChangeNotifierProvider.value(
        value: envController, child: EnvironmentContainer());
  }

  String get name => envController.environment.name;
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

  void addPage() {
    if (pageController.hasClients) {
      pageController.jumpToPage(pages.length - 1);
    }
    currentPage.value = pages.length - 1;
  }

  void addRequestPage(var data, {controller}) {
    pages.add(RequestPage(data, controller: controller));
    addPage();
  }

  void addEnvPage(Environment data) {
    pages.add(EnvironmentPage(data));
    addPage();
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
