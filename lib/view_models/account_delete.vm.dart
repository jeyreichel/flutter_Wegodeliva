import 'package:flutter/material.dart';
import 'package:vendorapp/services/auth.service.dart';
import 'package:vendorapp/view_models/base.view_model.dart';
import 'package:vendorapp/models/user.dart';
import 'package:vendorapp/requests/auth.request.dart';
import 'package:vendorapp/views/pages/splash.page.dart';
import 'package:velocity_x/velocity_x.dart';

class AccountDeleteViewModel extends MyBaseViewModel {
  //
  late User currentUser;
  AuthRequest _authRequest = AuthRequest();
  bool otherReason = false;
  String? reason;

  AccountDeleteViewModel(BuildContext context) {
    this.viewContext = context;
  }

  processAccountDeletion() async {
    _authRequest.delete("");
    if (formBuilderKey.currentState!.saveAndValidate()) {
      //
      setBusy(true);
      try {
        final formValue = formBuilderKey.currentState!.value;
        final apiResponse = await _authRequest.deleteProfile(
          password: formValue["password"],
          reason: reason,
        );
        if (apiResponse.allGood) {
          toastSuccessful("${apiResponse.message}");
          await AuthServices.logout();
          viewContext.nextAndRemoveUntilPage(
            SplashPage(),
          );
        } else {
          toastError("${apiResponse.message}");
        }
      } catch (error) {
        toastError("$error");
      }
      setBusy(false);
    }
  }
}
