import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vendorapp/models/service.dart';
import 'package:vendorapp/requests/service.request.dart';
import 'package:vendorapp/view_models/base.view_model.dart';
import 'package:vendorapp/views/pages/service/edit_service.page.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ServiceDetailsViewModel extends MyBaseViewModel {
  //
  ServiceDetailsViewModel(BuildContext context, this.service) {
    this.viewContext = context;
  }

  //
  ServiceRequest _serviceRequest = ServiceRequest();
  Service service;

  goBack() {
    viewContext.pop(service);
  }

  editService() async {
    //
    final result = await viewContext.push(
      (context) => EditServicePage(service),
    );
    if (result != null && result is Service) {
      service = result;
      notifyListeners();
    }
  }

  deleteService() {
    //
    CoolAlert.show(
      context: viewContext,
      type: CoolAlertType.confirm,
      title: "Delete Service".tr(),
      text: "Are you sure you want to delete service?".tr(),
      onConfirmBtnTap: () {
        //
        viewContext.pop();
        processDeletion();
      },
    );
  }

  processDeletion() async {
    //
    setBusy(true);
    try {
      final apiResponse = await _serviceRequest.deleteService(
        service,
      );

      //show dialog to present state
      CoolAlert.show(
        context: viewContext,
        type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
        title: "Delete Service".tr(),
        text: apiResponse.message,
        onConfirmBtnTap: apiResponse.allGood
            ? () {
                viewContext.pop();
                viewContext.pop(true);
              }
            : null,
      );
      clearErrors();
    } catch (error) {
      print("delete service Error ==> $error");
      setError(error);
    }
    setBusy(false);
  }
}
