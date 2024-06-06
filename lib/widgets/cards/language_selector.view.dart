import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:vendorapp/constants/app_languages.dart';
import 'package:vendorapp/services/auth.service.dart';
import 'package:vendorapp/utils/ui_spacer.dart';
import 'package:vendorapp/utils/utils.dart';
import 'package:vendorapp/widgets/custom_grid_view.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class AppLanguageSelector extends StatelessWidget {
  const AppLanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: VStack(
        [
          //
          "Select your preferred language"
              .tr()
              .text
              .xl
              .semiBold
              .make()
              .py20()
              .px12(),
          UiSpacer.divider(),

          //
          CustomGridView(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            padding: EdgeInsets.all(12),
            dataSet: AppLanguages.codes,
            itemBuilder: (ctx, index) {
              return VStack(
                [
                  //
                  Flag.fromString(
                    AppLanguages.flags[index],
                    height: 40,
                    width: 40,
                  ),
                  UiSpacer.verticalSpace(space: 5),
                  //
                  AppLanguages.names[index].text.lg.make(),
                ],
                crossAlignment: CrossAxisAlignment.center,
                alignment: MainAxisAlignment.center,
              ).box.roundedSM.color(context.canvasColor).make().onTap(() {
                _onSelected(context, AppLanguages.codes[index]);
              });
            },
          ).expand(),
        ],
      ),
    ).hThreeForth(context);
  }

  void _onSelected(BuildContext context, String code) async {
    await AuthServices.setLocale(code);
    await Utils.setJiffyLocale();
    //
    await translator.setNewLanguage(
      context,
      newLanguage: code,
      remember: true,
      restart: true,
    );
    //
    context.pop();
  }
}
