import 'package:dune/screens/request_container/request_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainTabController extends GetxController {
  final tabs = [].obs;
  final pages = [].obs;
  final currentPage = 0.obs;

  final PageController pageController = PageController();

  void addPage() {
    pages.add(RequestContainer());
    pageController.jumpToPage(pages.length - 1);
    currentPage.value = pages.length - 1;
  }

  void removePage(int position) {
    pages.removeAt(position);
    pageController.jumpToPage(pages.length - 1);
  }

  void changePage(int position) {
    pageController.jumpToPage(position);
    currentPage.value = position;
  }
}
