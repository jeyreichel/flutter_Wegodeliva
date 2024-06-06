import 'package:flutter/material.dart';
import 'package:vendorapp/constants/app_colors.dart';
import 'package:vendorapp/utils/ui_spacer.dart';
import 'package:vendorapp/view_models/orders.vm.dart';
import 'package:vendorapp/widgets/base.page.dart';
import 'package:vendorapp/widgets/buttons/custom_button.dart';
import 'package:vendorapp/widgets/custom_list_view.dart';
import 'package:vendorapp/widgets/list_items/order.list_item.dart';
import 'package:vendorapp/widgets/list_items/unpaid_order.list_item.dart';
import 'package:vendorapp/widgets/states/error.state.dart';
import 'package:vendorapp/widgets/states/order.empty.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with AutomaticKeepAliveClientMixin<OrdersPage> {
  //
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: ViewModelBuilder<OrdersViewModel>.reactive(
        viewModelBuilder: () => OrdersViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return BasePage(
            body: VStack(
              [
                //
                "Orders".tr().text.xl2.semiBold.make().p20(),
                //order status
                CustomListView(
                  scrollDirection: Axis.horizontal,
                  dataSet: vm.statuses,
                  padding: EdgeInsets.symmetric(horizontal: Vx.dp20),
                  itemBuilder: (context, index) {
                    //
                    final status = vm.statuses[index];
                    //
                    return CustomButton(
                      title: status.toLowerCase().tr().allWordsCapitilize(),
                      onPressed: () => vm.statusChanged(status),
                      color: status == vm.selectedStatus
                          ? AppColor.primaryColor
                          : Colors.grey.shade600,
                    );
                  },
                ).h(50).py12(),
                UiSpacer.verticalSpace(),
                //
                CustomListView(
                  canRefresh: true,
                  canPullUp: true,
                  refreshController: vm.refreshController,
                  onRefresh: vm.fetchMyOrders,
                  onLoading: () => vm.fetchMyOrders(initialLoading: false),
                  isLoading: vm.isBusy,
                  dataSet: vm.orders,
                  hasError: vm.hasError,
                  errorWidget: LoadingError(
                    onrefresh: vm.fetchMyOrders,
                  ),
                  //
                  emptyWidget: EmptyOrder(),
                  separatorBuilder: (context, index) =>
                      UiSpacer.verticalSpace(space: 5),
                  itemBuilder: (context, index) {
                    //
                    final order = vm.orders[index];
                    if (order.isUnpaid) {
                      return UnPaidOrderListItem(order: order);
                    }
                    return OrderListItem(
                      order: order,
                      orderPressed: () => vm.openOrderDetails(order),
                    );
                  },
                ).px20().expand(),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
