import 'package:flutter/material.dart';
import 'package:vendorapp/utils/ui_spacer.dart';
import 'package:vendorapp/widgets/buttons/custom_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class OrderEditStatusBottomSheet extends StatefulWidget {
  OrderEditStatusBottomSheet(
    this.selectedStatus, {
    required this.onConfirm,
    Key? key,
  }) : super(key: key);

  final Function(String) onConfirm;
  final String selectedStatus;
  @override
  _OrderEditStatusBottomSheetState createState() =>
      _OrderEditStatusBottomSheetState();
}

class _OrderEditStatusBottomSheetState
    extends State<OrderEditStatusBottomSheet> {
  //
  List<String> statues = [
    'pending',
    'preparing',
    'ready',
    'enroute',
    'failed',
    'cancelled',
    'delivered'
  ];
  String? selectedStatus;

  @override
  void initState() {
    super.initState();

    //
    setState(() {
      selectedStatus = widget.selectedStatus;
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: VStack(
        [
          //
          "Change Order Status".tr().text.semiBold.xl.make(),
          //
          ...statues.map((e) {
            //
            return HStack(
              [
                //
                Radio(
                  value: e,
                  groupValue: selectedStatus,
                  onChanged: _changeSelectedStatus,
                ),

                //
                e.tr().allWordsCapitilize().text.lg.light.make(),
              ],
            ).onInkTap(() => _changeSelectedStatus(e)).wFull(context);
          }).toList(),

          //
          UiSpacer.verticalSpace(),
          //
          CustomButton(
            title: "Change".tr(),
            onPressed: selectedStatus != null
                ? () => widget.onConfirm(selectedStatus!)
                : null,
          ),
        ],
      ).p20().scrollVertical().hTwoThird(context),
    );
  }

  void _changeSelectedStatus(value) {
    setState(() {
      selectedStatus = value;
    });
  }
}
