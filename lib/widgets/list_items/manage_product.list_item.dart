import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vendorapp/extensions/dynamic.dart';
import 'package:vendorapp/models/product.dart';
import 'package:vendorapp/constants/app_strings.dart';
import 'package:vendorapp/utils/ui_spacer.dart';
import 'package:vendorapp/widgets/buttons/custom_button.dart';
import 'package:vendorapp/widgets/currency_hstack.dart';
import 'package:vendorapp/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class ManageProductListItem extends StatelessWidget {
  //
  const ManageProductListItem(
    this.product, {
    this.isLoading = false,
    required this.onPressed,
    required this.onEditPressed,
    required this.onToggleStatusPressed,
    required this.onDeletePressed,
    Key? key,
  }) : super(key: key);

  //
  final Product product;
  final bool isLoading;
  final Function(Product) onPressed;
  final Function(Product) onEditPressed;
  final Function(Product) onToggleStatusPressed;
  final Function(Product) onDeletePressed;
  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;

    //
    return VStack(
      [
        //
        HStack(
          [
            //
            Hero(
              tag: product.heroTag ?? product.id,
              child: CustomImage(imageUrl: product.photo)
                  .wh(Vx.dp48, Vx.dp48)
                  .box
                  .clip(Clip.antiAlias)
                  .roundedSM
                  .make(),
            ),

            //Details
            VStack(
              [
                //name
                product.name.text.lg.medium.maxLines(3).ellipsis.make(),
                //
                HStack(
                  [
                    //discount
                    product.showDiscount
                        ? CurrencyHStack(
                            [
                              currencySymbol.text.lineThrough.xs.make(),
                              product.price
                                  .currencyValueFormat()
                                  .text
                                  .lineThrough
                                  .lg
                                  .medium
                                  .make(),
                            ],
                          )
                        : UiSpacer.emptySpace(),
                    UiSpacer.horizontalSpace(space: 10),
                    //price
                    CurrencyHStack(
                      [
                        currencySymbol.text.lg.make(),
                        (product.showDiscount
                                ? product.discountPrice
                                : product.price)
                            .currencyValueFormat()
                            .text
                            .xl
                            .semiBold
                            .make(),
                      ],
                      crossAlignment: CrossAxisAlignment.end,
                    ),
                  ],
                ),
              ],
            ).px12().expand(),
          ],
        ).p8(),
        UiSpacer.divider(),
        //actions
        HStack(
          [
            //
            CustomButton(
              loading: isLoading,
              height: 30,
              icon: FlutterIcons.edit_fea,
              // title: "Edit",
              onPressed: () => onEditPressed(product),
              color: Colors.grey,
            ),
            CustomButton(
              loading: isLoading,
              height: 30,
              icon: product.isActive != 1
                  ? FlutterIcons.check_ant
                  : FlutterIcons.close_ant,
              // title:
              //     (packageTypePricing.isActive != 1 ? "Activate" : "Deactivate")
              //         .tr(),
              onPressed: () => onToggleStatusPressed(product),
              color: product.isActive != 1 ? Colors.green : Colors.red[400],
            ).px12(),
            CustomButton(
              loading: isLoading,
              height: 30,
              icon: FlutterIcons.delete_ant,
              // title: "Delete".tr(),
              onPressed: () => onDeletePressed(product),
              color: Colors.red,
            ),
          ],
          alignment: MainAxisAlignment.spaceEvenly,
          crossAlignment: CrossAxisAlignment.center,
        ).centered().p8(),
        //
      ],
    ).onInkTap(() => onPressed(product)).card.make();
  }
}
