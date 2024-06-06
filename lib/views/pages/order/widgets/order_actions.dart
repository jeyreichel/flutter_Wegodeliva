import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vendorapp/models/order.dart';
import 'package:vendorapp/utils/ui_spacer.dart';
import 'package:vendorapp/widgets/busy_indicator.dart';
import 'package:vendorapp/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderActions extends StatelessWidget {
  const OrderActions({
    this.canChatCustomer,
    this.busy = false,
    required this.order,
    this.onEditPressed,
    this.onCancelledPressed,
    this.onAssignPressed,
    required this.onAcceptPressed,
    Key? key,
  }) : super(key: key);

  final bool? canChatCustomer;
  final bool busy;
  final Order order;
  final Function? onEditPressed;
  final Function? onCancelledPressed;
  final Function? onAcceptPressed;
  final Function? onAssignPressed;

  @override
  Widget build(BuildContext context) {
    return (!["failed", "cancelled", "delivered"].contains(order.status))
        ? SafeArea(
            child: busy
                ? BusyIndicator().centered().wh(Vx.dp40, Vx.dp40)
                : (order.status == "pending")
                    ? HStack(
                        [
                          CustomButton(
                            color: Colors.red,
                            title: "Reject".tr(),
                            onPressed: onCancelledPressed,
                          ).expand(),
                          UiSpacer.hSpace(),
                          CustomButton(
                            color: Colors.green,
                            title: "Accept".tr(),
                            onPressed: onAcceptPressed,
                          ).expand(),
                        ],
                      )
                    : VStack(
                        [
                          HStack(
                            [
                              //edit order
                              Expanded(
                                child: order.canEditStatus
                                    ? CustomButton(
                                        title: "Edit".tr(),
                                        icon: FlutterIcons.edit_ant,
                                        onPressed: onEditPressed,
                                      )
                                    : UiSpacer.emptySpace(),
                              ),
                              UiSpacer.horizontalSpace(),
                              //cancel order
                              Expanded(
                                child: order.canCancel
                                    ? CustomButton(
                                        color: Colors.red,
                                        title: "Cancel".tr(),
                                        icon: FlutterIcons.close_ant,
                                        onPressed: onCancelledPressed,
                                      )
                                    : UiSpacer.emptySpace(),
                              ),
                            ],
                          ),

                          //
                          order.canAssignDriver
                              ? UiSpacer.verticalSpace()
                              : UiSpacer.emptySpace(),
                          //assign driver
                          order.canAssignDriver
                              ? CustomButton(
                                  title: "Assign Order".tr(),
                                  icon: FlutterIcons.truck_delivery_mco,
                                  onPressed: onAssignPressed,
                                )
                              : UiSpacer.emptySpace(),
                        ],
                      ),
          )
            .box
            .p20
            .outerShadow2Xl
            .shadow
            .color(context.cardColor)
            .make()
            .wFull(context)
        : UiSpacer.emptySpace();
  }
}
