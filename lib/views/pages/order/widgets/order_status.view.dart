import 'package:flutter/material.dart';
import 'package:vendorapp/constants/app_colors.dart';
import 'package:vendorapp/utils/ui_spacer.dart';
import 'package:vendorapp/view_models/order_details.vm.dart';
import 'package:jiffy/jiffy.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class OrderStatusView extends StatelessWidget {
  const OrderStatusView(this.vm, {Key? key}) : super(key: key);

  final OrderDetailsViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        HStack(
          [
            VStack(
              [
                "Status".tr().text.gray500.medium.sm.make(),
                vm.order.status
                    .allWordsCapitilize()
                    .text
                    .color(AppColor.getStausColor(vm.order.status))
                    .medium
                    .xl
                    .make(),
              ],
            ).expand(),
            //Payment status
            VStack(
              [
                //
                "Payment Status".tr().text.gray500.medium.sm.make(),
                //
                "${vm.order.paymentStatus}"
                    .tr()
                    .capitalized
                    .text
                    .color(AppColor.getStausColor(vm.order.paymentStatus))
                    .medium
                    .xl
                    .make(),
                //
              ],
            ),
          ],
        ),

        //payment method
        Visibility(
          visible: vm.order.paymentMethod != null,
          child: Column(
            children: [
              UiSpacer.verticalSpace(),
              "Payment Method".tr().text.gray500.medium.sm.make(),
              "${vm.order.paymentMethod?.name ?? ''}".text.medium.xl.make(),
            ],
          ),
        ),

        UiSpacer.verticalSpace(),

        //scheduled order info
        vm.order.isScheduled
            ? HStack(
                [
                  //date
                  VStack(
                    [
                      //
                      "Scheduled Date".tr().text.gray500.medium.sm.make(),
                      "${vm.order.pickupDate}"
                          .text
                          .color(AppColor.getStausColor(vm.order.status))
                          .medium
                          .xl
                          .make()
                          .pOnly(bottom: Vx.dp20),
                    ],
                  ).expand(),
                  //time
                  VStack(
                    [
                      //
                      "Scheduled Time".tr().text.gray500.medium.sm.make(),
                      "${Jiffy(vm.order.pickupTime).format("hh:mm a")}"
                          .text
                          .color(AppColor.getStausColor(vm.order.status))
                          .medium
                          .xl
                          .make()
                          .pOnly(bottom: Vx.dp20),
                    ],
                  ),
                ],
              )
            : UiSpacer.emptySpace(),
      ],
    );
  }
}
