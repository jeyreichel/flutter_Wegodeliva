import 'package:flutter/material.dart';
import 'package:vendorapp/constants/app_images.dart';
import 'package:vendorapp/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptyOrder extends StatelessWidget {
  const EmptyOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      imageUrl: AppImages.emptyCart,
      title: "No Order".tr(),
      description: "When you are assigned an order, they will appear here".tr(),
    ).p20().centered();
  }
}
