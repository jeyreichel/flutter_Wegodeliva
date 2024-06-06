import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendorapp/constants/app_strings.dart';
import 'package:vendorapp/models/delivery_address.dart';
import 'package:vendorapp/services/toast.service.dart';
import 'package:vendorapp/services/update.service.dart';
import 'package:vendorapp/views/pages/shared/custom_webview.page.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

class MyBaseViewModel extends BaseViewModel with UpdateService {
  //
  late BuildContext viewContext;
  final formKey = GlobalKey<FormState>();
  final formBuilderKey = GlobalKey<FormBuilderState>();
  final currencySymbol = AppStrings.currencySymbol;
  GlobalKey pageKey = GlobalKey<FormState>();
  DeliveryAddress? deliveryaddress;
  String? firebaseVerificationId;

  void initialise() {
    //FirestoreRepository();
  }

  newPageKey() {
    pageKey = GlobalKey<FormState>();
    notifyListeners();
  }

  //show toast
  toastSuccessful(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  toastError(String msg, {Toast? length}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: length ?? Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  openWebpageLink(String url, {bool external = false}) async {
    if (Platform.isIOS || external) {
      await launchUrlString(url);
      return;
    }
    await viewContext.push(
      (context) => CustomWebviewPage(
        selectedUrl: url,
      ),
    );
  }

  Future<dynamic> openExternalWebpageLink(String url) async {
    try {
      await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );
      return;
    } catch (error) {
      ToastService.toastError("$error");
    }
  }
}
