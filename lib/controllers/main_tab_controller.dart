import 'package:dune/controllers/response_controller.dart';
import 'package:dune/widgets/request_container/request_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Page {
  ResponseController responseController = ResponseController();
  late Widget page;

  Page() {
    page = ChangeNotifierProvider.value(
        value: responseController, child: RequestContainer());
  }

  String get name => responseController.nameInputController.text;
  String get method =>
      responseController.methodDropDownController.value!['name'];
}

class MainTabController extends GetxController {
  final pages = [].obs;
  final currentPage = 0.obs;

  final PageController pageController = PageController();

  MainTabController() {
    addPage();
  }

  void addPage() {
    pages.add(Page());
    if (pageController.hasClients) {
      pageController.jumpToPage(pages.length - 1);
    }
    currentPage.value = pages.length - 1;
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
  }
}
