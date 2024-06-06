import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vendorapp/constants/api.dart';
import 'package:vendorapp/constants/app_images.dart';
import 'package:vendorapp/view_models/profile.vm.dart';
import 'package:vendorapp/views/pages/profile/paymet_accounts.page.dart';
import 'package:vendorapp/widgets/busy_indicator.dart';
import 'package:vendorapp/widgets/menu_item.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(this.model, {Key? key}) : super(key: key);

  final ProfileViewModel model;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //profile card
        (model.isBusy || model.currentUser == null)
            ? BusyIndicator().centered().p20()
            : HStack(
                [
                  //
                  CachedNetworkImage(
                    imageUrl: model.currentUser!.photo,
                    progressIndicatorBuilder: (context, imageUrl, progress) {
                      return BusyIndicator();
                    },
                    errorWidget: (context, imageUrl, progress) {
                      return Image.asset(
                        AppImages.user,
                      );
                    },
                  )
                      .wh(Vx.dp64, Vx.dp64)
                      .box
                      .roundedFull
                      .clip(Clip.antiAlias)
                      .make(),

                  //
                  VStack(
                    [
                      //name
                      model.currentUser!.name.text.xl.semiBold.make(),
                      //email
                      model.currentUser!.email.text.light.make(),
                    ],
                  ).px20().expand(),

                  //
                ],
              ).p12(),

        //
        Visibility(
          visible: !Platform.isIOS,
          child: MenuItem(
            title: "Web Admin".tr(),
            onPressed: () async {
              try {
                final url = await Api.redirectAuth(Api.backendUrl);
                model.openExternalWebpageLink(url);
              } catch (error) {
                model.toastError("$error");
              }
            },
            topDivider: true,
          ),
        ),
        //
        MenuItem(
          title: "Payment Accounts".tr(),
          onPressed: () {
            context.push((ctx) => PaymentAccountsPage());
          },
          topDivider: true,
        ),
        //
        MenuItem(
          title: "Edit Profile".tr(),
          onPressed: model.openEditProfile,
          topDivider: true,
        ),
        //change password
        MenuItem(
          title: "Change Password".tr(),
          onPressed: model.openChangePassword,
          topDivider: true,
        ),
        //
        MenuItem(
          child: "Logout".tr().text.bold.lg.make(),
          onPressed: model.logoutPressed,
          suffix: Icon(
            FlutterIcons.logout_ant,
            size: 16,
          ),
        ),
        MenuItem(
          child: "Delete Account".tr().text.red500.lg.make(),
          onPressed: model.deleteAccount,
          divider: false,
          suffix: Icon(
            FlutterIcons.x_circle_fea,
            size: 16,
            color: Vx.red600,
          ),
        ),
      ],
    )
        .wFull(context)
        .box
        // .border(color: Theme.of(context).cardColor)
        // .color(Theme.of(context).cardColor)
        .color(Theme.of(context).colorScheme.background)
        .outerShadow
        .withRounded(value: 5)
        .make();
  }
}
