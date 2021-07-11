import 'package:dune/controllers/response_controller.dart';
import 'package:dune/widgets/request_container/request_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Page {
  ResponseController responseController = ResponseController();
  late Widget page;
  late String method;

  Page() {
    page = ChangeNotifierProvider.value(
        value: responseController, child: RequestContainer());
    method = responseController.methodDropDownController.value!['name'];
  }

  String get name => responseController.nameInputController.text;
}

class MainTabController extends GetxController {
  final pages = [].obs;
  final currentPage = 0.obs;

  final PageController pageController = PageController();

  void addPage() {
    pages.add(Page());
    pageController.jumpToPage(pages.length - 1);
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
