import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vendorapp/constants/app_colors.dart';
import 'package:vendorapp/services/custom_form_builder_validator.service.dart';
import 'package:vendorapp/utils/ui_spacer.dart';
import 'package:vendorapp/view_models/new_products.vm.dart';
import 'package:vendorapp/widgets/base.page.dart';
import 'package:vendorapp/widgets/busy_indicator.dart';
import 'package:vendorapp/widgets/buttons/custom_button.dart';
import 'package:vendorapp/widgets/cards/multi_image_selector.dart';
import 'package:vendorapp/widgets/html_text_view.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NewProductPage extends StatelessWidget {
  const NewProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewProductViewModel>.reactive(
      viewModelBuilder: () => NewProductViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showLeadingAction: true,
          showAppBar: true,
          title: "New Product".tr(),
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
                    decoration: InputDecoration(
                      labelText: 'Name'.tr(),
                    ),
                    onChanged: (value) {},
                    validator: CustomFormBuilderValidator.required,
                  ),
                  UiSpacer.verticalSpace(),
                  //image
                  MultiImageSelectorView(
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
                            title: vm.productDescription == null
                                ? "Add".tr()
                                : "Edit".tr(),
                            onPressed: vm.handleDescriptionEdit,
                            icon: vm.productDescription == null
                                ? FlutterIcons.add_mdi
                                : FlutterIcons.edit_mdi,
                          ).h(30),
                        ],
                      ),
                      UiSpacer.vSpace(10),
                      //preview description
                      HtmlTextView(vm.productDescription ?? "", padding: 0),
                    ],
                  ).p(10).box.border().roundedSM.make(),

                  UiSpacer.verticalSpace(),
                  //pricing
                  HStack(
                    [
                      //price
                      FormBuilderTextField(
                        name: 'price',
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
                        decoration: InputDecoration(
                          labelText: 'Discount Price'.tr(),
                        ),
                        onChanged: (value) {},
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
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
                        initialValue: false,
                        name: 'deliverable',
                        onChanged: (value) {},
                        valueTransformer: (value) => (value ?? false) ? 1 : 0,
                        title: "Can be delivered".tr().text.make(),
                      ).expand(),
                      20.widthBox,
                      //Active
                      FormBuilderCheckbox(
                        initialValue: false,
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
                          decoration: InputDecoration(
                            labelText: 'Category'.tr(),
                          ),
                          spacing: 5,
                          selectedColor: AppColor.primaryColor,
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
                          decoration: InputDecoration(
                            labelText: 'Sub-Category'.tr(),
                          ),
                          spacing: 5,
                          checkmarkColor: AppColor.primaryColor,
                          options: vm.subCategories
                              .map(
                                (category) => FormBuilderChipOption<String>(
                                  value: '${category.id}',
                                  child: '${category.name}'.text.make(),
                                ),
                              )
                              .toList(),
                        ),
                  UiSpacer.verticalSpace(),
                  //menus
                  vm.busy(vm.menus)
                      ? BusyIndicator().centered()
                      : FormBuilderFilterChip<String>(
                          name: 'menu_ids',
                          decoration: InputDecoration(
                            labelText: 'Menus'.tr(),
                          ),
                          spacing: 5,
                          selectedColor: AppColor.primaryColor,
                          options: vm.menus
                              .map(
                                (menu) => FormBuilderChipOption<String>(
                                  value: '${menu.id}',
                                  child: '${menu.name}'.text.make(),
                                ),
                              )
                              .toList(),
                        ),
                  UiSpacer.verticalSpace(),
                  //
                  CustomButton(
                    title: "Save Product".tr(),
                    loading: vm.isBusy,
                    onPressed: vm.processNewProduct,
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
