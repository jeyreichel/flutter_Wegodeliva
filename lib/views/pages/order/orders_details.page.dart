import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vendorapp/constants/app_colors.dart';
import 'package:vendorapp/constants/app_ui_settings.dart';
import 'package:vendorapp/extensions/dynamic.dart';
import 'package:vendorapp/models/order.dart';
import 'package:vendorapp/constants/app_strings.dart';
import 'package:vendorapp/utils/ui_spacer.dart';
import 'package:vendorapp/utils/utils.dart';
import 'package:vendorapp/view_models/order_details.vm.dart';
import 'package:vendorapp/views/pages/order/widgets/order_actions.dart';
import 'package:vendorapp/views/pages/order/widgets/order_address.view.dart';
import 'package:vendorapp/views/pages/order/widgets/order_attachment.view.dart';
import 'package:vendorapp/views/pages/order/widgets/order_details_items.view.dart';
import 'package:vendorapp/views/pages/order/widgets/order_status.view.dart';
import 'package:vendorapp/widgets/base.page.dart';
import 'package:vendorapp/widgets/buttons/custom_button.dart';
import 'package:vendorapp/widgets/cards/order_summary.dart';
import 'package:vendorapp/widgets/currency_hstack.dart';
import 'package:vendorapp/widgets/states/custom_loading.state.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({
    required this.order,
    Key? key,
  }) : super(key: key);

  //
  final Order order;

  @override
  Widget build(BuildContext context) {
    //
    return ViewModelBuilder<OrderDetailsViewModel>.reactive(
      viewModelBuilder: () => OrderDetailsViewModel(context, order),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          title: "",
          showAppBar: true,
          showLeadingAction: true,
          elevation: 0,
          onBackPressed: vm.onBackPressed,
          isLoading: vm.isBusy,
          backgroundColor: Colors.grey.shade100,
          body: CustomLoadingStateView(
            loading: vm.isBusy,
            child: VStack(
              [
                //intro
                //code& price
                VxBox(
                  child: HStack(
                    [
                      VStack(
                        [
                          "Order Details"
                              .tr()
                              .text
                              .color(Utils.textColorByTheme())
                              .semiBold
                              .xl3
                              .make(),
                          UiSpacer.vSpace(5),
                          //
                          "#${vm.order.code}"
                              .text
                              .color(Utils.textColorByTheme())
                              .semiBold
                              .medium
                              .xl
                              .make(),
                        ],
                      ).expand(),
                      UiSpacer.hSpace(),
                      //total amount
                      CurrencyHStack(
                        [
                          AppStrings.currencySymbol.text
                              .color(Utils.textColorByTheme())
                              .medium
                              .xl
                              .make()
                              .px4(),
                          (vm.order.total ?? 0.00)
                              .currencyValueFormat()
                              .text
                              .color(Utils.textColorByTheme())
                              .semiBold
                              .xl3
                              .make(),
                        ],
                      ),
                    ],
                  ).pOnly(bottom: 10),
                )
                    .p20
                    .bottomRounded(value: 20)
                    .color(AppColor.primaryColor)
                    .make()
                    .wFull(context),

                VStack(
                  [
                    //status
                    orderSection(OrderStatusView(vm), context),

                    // either products/package details
                    orderSection(
                      OrderDetailsItemsView(vm),
                      context,
                    ),

                    //attachements
                    Visibility(
                      visible: vm.order.attachments != null &&
                          vm.order.attachments!.isNotEmpty,
                      child: orderSection(
                        OrderAttachmentView(vm),
                        context,
                      ),
                    ),

                    //show package delivery addresses
                    orderSection(OrderAddressView(vm), context),

                    //driver
                    Visibility(
                      visible: vm.order.driver != null,
                      child: orderSection(
                        VStack(
                          [
                            HStack(
                              [
                                //
                                VStack(
                                  [
                                    "Driver".tr().text.gray500.medium.sm.make(),
                                    (vm.order.driver?.name ?? "")
                                        .text
                                        .medium
                                        .xl
                                        .make()
                                        .pOnly(bottom: Vx.dp20),
                                  ],
                                ).expand(),
                                //call
                                Visibility(
                                  visible: AppUISettings.canCallDriver,
                                  child: CustomButton(
                                    icon: FlutterIcons.phone_call_fea,
                                    iconColor: Colors.white,
                                    color: AppColor.primaryColor,
                                    shapeRadius: Vx.dp20,
                                    onPressed: vm.callDriver,
                                  ).wh(Vx.dp64, Vx.dp40).p12(),
                                ),
                              ],
                            ),

                            //chat
                            Visibility(
                              visible: vm.order.canChatDriver &&
                                  AppUISettings.canDriverChat,
                              child: CustomButton(
                                icon: FlutterIcons.chat_ent,
                                iconColor: Colors.white,
                                title: "Chat with driver".tr(),
                                color: AppColor.primaryColor,
                                onPressed: vm.chatDriver,
                              ).h(Vx.dp48).pOnly(top: Vx.dp12, bottom: Vx.dp20),
                            ),
                          ],
                        ),
                        context,
                      ),
                    ),

                    //customer
                    orderSection(
                      VStack(
                        [
                          HStack(
                            [
                              //
                              VStack(
                                [
                                  "Customer".tr().text.gray500.medium.sm.make(),
                                  vm.order.user.name.text.medium.xl.make(),
                                ],
                              ).expand(),
                              //call

                              Visibility(
                                visible: vm.order.canChatCustomer &&
                                    AppUISettings.canCallDriver,
                                child: CustomButton(
                                  icon: FlutterIcons.phone_call_fea,
                                  iconColor: Colors.white,
                                  color: AppColor.primaryColor,
                                  shapeRadius: Vx.dp20,
                                  onPressed: vm.callCustomer,
                                ).wh(Vx.dp64, Vx.dp40).p12(),
                              ),
                            ],
                          ),
                          //chat btn
                          Visibility(
                            visible: vm.order.canChatCustomer &&
                                AppUISettings.canCustomerChat,
                            child: CustomButton(
                              icon: FlutterIcons.chat_ent,
                              iconColor: Colors.white,
                              title: "Chat with customer".tr(),
                              color: AppColor.primaryColor,
                              onPressed: vm.chatCustomer,
                            ).h(Vx.dp48).pOnly(top: Vx.dp12, bottom: Vx.dp20),
                          ),
                        ],
                      ),
                      context,
                    ),

                    //recipient
                    // RecipientInfo(
                    //   callRecipient: vm.callRecipient,
                    //   order: vm.order,
                    // ),

                    //note
                    orderSection(
                      VStack(
                        [
                          "Note".tr().text.gray500.medium.sm.make(),
                          (vm.order.note).text.medium.xl.italic.make(),
                        ],
                      ),
                      context,
                    ),

                    UiSpacer.verticalSpace(),

                    //order summary
                    orderSection(
                      OrderSummary(
                        subTotal: vm.order.subTotal,
                        driverTrip: vm.order.tip,
                        discount: vm.order.discount,
                        deliveryFee: vm.order.deliveryFee,
                        tax: vm.order.tax,
                        vendorTax: vm.order.taxRate.toString(),
                        total: vm.order.total,
                        fees: vm.order.fees ?? [],
                      ),
                      context,
                    ),
                  ],
                ).p12().pOnly(bottom: context.percentHeight * 20),
              ],
            ).scrollVertical().box.make(),
          ),

          //fab printing
          fab: Platform.isAndroid
              ? FloatingActionButton.extended(
                  onPressed: () => vm.printOrder(),
                  label: "Print".text.white.make(),
                  backgroundColor: AppColor.primaryColor,
                  icon: Icon(
                    FlutterIcons.print_faw,
                    color: Colors.white,
                  ),
                )
              : null,
          //bottomsheet
          bottomSheet: vm.order.canShowActions
              ? OrderActions(
                  order: vm.order,
                  canChatCustomer: vm.order.canChatCustomer,
                  busy: vm.isBusy || vm.busy(vm.order),
                  onEditPressed: vm.changeOrderStatus,
                  onAssignPressed: vm.assignOrder,
                  onCancelledPressed: vm.processOrderCancellation,
                  onAcceptPressed: () => vm.processStatusUpdate('preparing'),
                )
              : null,
        );
      },
    );
  }

  Widget orderSection(Widget child, BuildContext context) {
    return child
        .wFull(context)
        .box
        .shadowSm
        .color(context.theme.colorScheme.background)
        .p12
        .roundedSM
        .make()
        .pOnly(bottom: 12);
  }
}
