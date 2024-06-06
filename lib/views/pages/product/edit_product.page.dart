import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vendorapp/constants/app_colors.dart';
import 'package:vendorapp/models/product.dart';
import 'package:vendorapp/services/custom_form_builder_validator.service.dart';
import 'package:vendorapp/utils/ui_spacer.dart';
import 'package:vendorapp/view_models/edit_products.vm.dart';
import 'package:vendorapp/widgets/base.page.dart';
import 'package:vendorapp/widgets/busy_indicator.dart';
import 'package:vendorapp/widgets/buttons/custom_button.dart';
import 'package:vendorapp/widgets/cards/multi_image_selector.dart';
import 'package:vendorapp/widgets/html_text_view.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EditProductPage extends StatelessWidget {
  const EditProductPage(this.product, {Key? key}) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProductViewModel>.reactive(
      viewModelBuilder: () => EditProductViewModel(context, product),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showLeadingAction: true,
          showAppBar: true,
          title: "Edit Product".tr(),
          body: SafeArea(
            top: true,
            bottom: false,
            child: FormBuilder(
              key: vm.formBuilderKey,
              child: VStack(
                [
                  //name
                  FormBuilderTextField(
                    name: 'name',
                    initialValue: product.name,
                    decoration: InputDecoration(
                      labelText: 'Name'.tr(),
                    ),
                    onChanged: (value) {},
                    validator: CustomFormBuilderValidator.required,
                  ),
                  UiSpacer.verticalSpace(),
                  //image
                  MultiImageSelectorView(
                    links: product.photos,
                    onImagesSelected: vm.onImagesSelected,
                  ),
                  UiSpacer.verticalSpace(),
                  VStack(
                    [
                      //hstack with Description text expanded and edit button
                      HStack(
                        [
                          "Description".tr().text.make().expand(),
                          CustomButton(
                            title: vm.product.description == null
                                ? "Add".tr()
                                : "Edit".tr(),
                            onPressed: vm.handleDescriptionEdit,
                            icon: vm.product.description == null
                                ? FlutterIcons.add_mdi
                                : FlutterIcons.edit_mdi,
                          ).h(30),
                        ],
                      ),
                      UiSpacer.vSpace(10),
                      //preview description
                      HtmlTextView(vm.product.description, padding: 0),
                    ],
                  ).p(10).box.border().roundedSM.make(),
                  UiSpacer.verticalSpace(),
                  //pricing
                  HStack(
                    [
                      //price
                      FormBuilderTextField(
                        name: 'price',
                        initialValue: product.price.toString(),
                        decoration: InputDecoration(
                          labelText: 'Price'.tr(),
                        ),
                        onChanged: (value) {},
                        validator: (value) =>
                            CustomFormBuilderValidator.compose([
                          CustomFormBuilderValidator.required(value),
                          CustomFormBuilderValidator.numeric(value),
                        ]),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                      ).expand(),
                      UiSpacer.horizontalSpace(),
                      //Discount price
                      FormBuilderTextField(
                        name: 'discount_price',
                        initialValue: product.discountPrice.toString(),
                        decoration: InputDecoration(
                          labelText: 'Discount Price'.tr(),
                        ),
                        onChanged: (value) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                      ).expand(),
                    ],
                  ),
                  //
                  UiSpacer.verticalSpace(),
                  //packaging
                  HStack(
                    [
                      //Capacity
                      FormBuilderTextField(
                        name: 'capacity',
                        initialValue: product.capacity,
                        decoration: InputDecoration(
                          labelText: 'Capacity'.tr(),
                        ),
                        onChanged: (value) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                      ).expand(),
                      UiSpacer.horizontalSpace(),
                      //unit
                      FormBuilderTextField(
                        name: 'unit',
                        initialValue: product.unit,
                        decoration: InputDecoration(
                          labelText: 'Unit'.tr(),
                        ),
                        onChanged: (value) {},
                      ).expand(),
                    ],
                  ),
                  //
                  UiSpacer.verticalSpace(),
                  //pricing
                  HStack(
                    [
                      //package_count
                      FormBuilderTextField(
                        name: 'package_count',
                        initialValue: product.packageCount,
                        decoration: InputDecoration(
                          labelText: 'Package Count'.tr(),
                        ),
                        onChanged: (value) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                      ).expand(),
                      UiSpacer.horizontalSpace(),
                      //available_qty
                      FormBuilderTextField(
                        name: 'available_qty',
                        initialValue: product.availableQty != null
                            ? product.availableQty.toString()
                            : "",
                        decoration: InputDecoration(
                          labelText: 'Available Qty'.tr(),
                        ),
                        onChanged: (value) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                      ).expand(),
                    ],
                  ),
                  //
                  UiSpacer.vSpace(10),
                  HStack(
                    [
                      //deliverable
                      FormBuilderCheckbox(
                        initialValue: product.deliverable == 1,
                        name: 'deliverable',
                        onChanged: (value) {},
                        valueTransformer: (value) => (value ?? false) ? 1 : 0,
                        title: "Can be delivered".tr().text.make(),
                      ).expand(),
                      20.widthBox,
                      //Active
                      FormBuilderCheckbox(
                        initialValue: product.isActive == 1,
                        name: 'is_active',
                        onChanged: (value) {},
                        valueTransformer: (value) => (value ?? false) ? 1 : 0,
                        title: "Active".tr().text.make(),
                      ).expand(),
                    ],
                  ),
                  //
                  UiSpacer.vSpace(10),

                  //categories
                  vm.busy(vm.categories)
                      ? BusyIndicator().centered()
                      : FormBuilderFilterChip<String>(
                          name: 'category_ids',
                          initialValue: product.categories
                              .map((category) => category.id.toString())
                              .toList(),
                          decoration: InputDecoration(
                            labelText: 'Category'.tr(),
                          ),
                          spacing: 5,
                          // selectedColor: AppColor.primaryColor,
                          checkmarkColor: AppColor.primaryColor,
                          options: vm.categories
                              .map(
                                (category) => FormBuilderChipOption<String>(
                                  value: '${category.id}',
                                  child: '${category.name}'.text.make(),
                                ),
                              )
                              .toList(),
                          onChanged: vm.filterSubcategories,
                        ),
                  UiSpacer.vSpace(10),
                  //subcategories
                  vm.busy(vm.subCategories)
                      ? BusyIndicator().centered()
                      : FormBuilderFilterChip<String>(
                          name: 'sub_category_ids',
                          initialValue: product.subCategories
                              .map((category) => category.id.toString())
                              .toList(),
                          decoration: InputDecoration(
                            labelText: 'Sub-Category'.tr(),
                          ),
                          spacing: 5,
                          selectedColor: AppColor.primaryColor,
                          options: vm.subCategories
                              .map(
                                (category) => FormBuilderChipOption<String>(
                                  value: '${category.id}',
                                  child: Text('${category.name}'),
                                ),
                              )
                              .toList(),
                          valueTransformer: (newValue) {
                            if (newValue == null || newValue.isEmpty) {
                              return [];
                            }
                            //make the value a list of int
                            return newValue
                                .map((value) => int.parse(value))
                                .toList();
                          },
                        ),
                  UiSpacer.verticalSpace(),
                  //menus
                  vm.busy(vm.menus)
                      ? BusyIndicator().centered()
                      : FormBuilderFilterChip(
                          name: 'menu_ids',
                          initialValue: product.menus
                              .map((menu) => menu.id.toString())
                              .toList(),
                          decoration: InputDecoration(
                            labelText: 'Menus'.tr(),
                          ),
                          spacing: 5,
                          selectedColor: AppColor.primaryColor,
                          options: vm.menus
                              .map(
                                (menu) => FormBuilderChipOption<String>(
                                  value: '${menu.id}',
                                  child: Text('${menu.name}'),
                                ),
                              )
                              .toList(),
                        ),
                  UiSpacer.verticalSpace(),
                  //
                  CustomButton(
                    title: "Save Product".tr(),
                    loading: vm.isBusy,
                    onPressed: vm.processUpdateProduct,
                  ).centered().py12(),
                ],
              ),
            )
                .p20()
                .scrollVertical()
                .pOnly(bottom: context.mq.viewInsets.bottom),
          ),
        );
      },
    );
  }
}
