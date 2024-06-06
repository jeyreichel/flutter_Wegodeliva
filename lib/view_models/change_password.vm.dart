import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendorapp/models/user.dart';
import 'package:vendorapp/requests/auth.request.dart';
import 'package:vendorapp/view_models/base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ChangePasswordViewModel extends MyBaseViewModel {
  late User currentUser;
  //the textediting controllers
  TextEditingController currentPasswordTEC = new TextEditingController();
  TextEditingController newPasswordTEC = new TextEditingController();
  TextEditingController confirmNewPasswordTEC = new TextEditingController();

  //
  AuthRequest _authRequest = AuthRequest();
  final picker = ImagePicker();

  ChangePasswordViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  processUpdate() async {
    //
    if (formKey.currentState!.validate()) {
      //
      setBusy(true);

      //
      final apiResponse = await _authRequest.updatePassword(
        password: currentPasswordTEC.text,
        new_password: newPasswordTEC.text,
        new_password_confirmation: confirmNewPasswordTEC.text,
      );

      //
      setBusy(false);

      //
      CoolAlert.show(
        context: viewContext,
        type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
        title: "Change Password".tr(),
        text: apiResponse.message,
        onConfirmBtnTap: apiResponse.allGood
            ? () {
                //
                viewContext.pop();
                viewContext.pop(true);
              }
            : null,
      );
    }
  }
}
