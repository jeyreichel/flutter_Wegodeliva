import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vendorapp/models/vendor.dart';
import 'package:vendorapp/services/app.service.dart';
import 'package:vendorapp/services/auth.service.dart';
import 'package:vendorapp/services/in_app_order_notification.service.dart';
import 'package:vendorapp/view_models/base.view_model.dart';

class HomeViewModel extends MyBaseViewModel {
  //
  HomeViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  int currentIndex = 0;
  PageController pageViewController = PageController(initialPage: 0);
  int totalCartItems = 0;
  StreamSubscription? homePageChangeStream;
  Vendor? currentVendor;

  @override
  void initialise() async {
    //
    InAppOrderNotificationService().handleBringAppToForeground(viewContext);
    //
    currentVendor = await AuthServices.getCurrentVendor(force: true);
    notifyListeners();
    //

    //
    homePageChangeStream = AppService().homePageIndex.stream.listen(
      (index) {
        //
        onTabChange(index);
      },
    );
  }

  //
  dispose() {
    super.dispose();
    homePageChangeStream?.cancel();
  }

  //
  onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  //
  onTabChange(int index) {
    currentIndex = index;
    pageViewController.animateToPage(
      currentIndex,
      duration: Duration(microseconds: 5),
      curve: Curves.bounceInOut,
    );
    notifyListeners();
  }
}
