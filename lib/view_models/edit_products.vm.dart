import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:vendorapp/models/menu.dart';
import 'package:vendorapp/models/product.dart';
import 'package:vendorapp/models/product_category.dart';
import 'package:vendorapp/models/vendor.dart';
import 'package:vendorapp/requests/product.request.dart';
import 'package:vendorapp/requests/vendor.request.dart';
import 'package:vendorapp/services/auth.service.dart';
import 'package:vendorapp/view_models/base.view_model.dart';
import 'package:vendorapp/views/pages/shared/text_editor.page.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EditProductViewModel extends MyBaseViewModel {
  //
  EditProductViewModel(BuildContext context, this.product) {
    this.viewContext = context;
  }

  //
  ProductRequest productRequest = ProductRequest();
  VendorRequest vendorRequest = VendorRequest();
  late Product product;
  List<ProductCategory> categories = [];
  List<ProductCategory> subCategories = [];
  List<ProductCategory> unFilterSubCategories = [];
  List<Menu> menus = [];
  List<File> selectedPhotos = [];

  void initialise() {
    fetchProductCategories();
    fetchProductSubCategories();
    fetchMenus();
  }

  //
  fetchProductCategories() async {
    setBusyForObject(categories, true);

    try {
      categories = await productRequest.getProductCategories(
        vendorTypeId:
            (await AuthServices.getCurrentVendor(force: true)).vendorType?.id,
      );
      clearErrors();
    } catch (error) {
      print("Categories Error ==> $error");
      setError(error);
    }

    setBusyForObject(categories, false);
  }

  fetchProductSubCategories() async {
    setBusyForObject(subCategories, true);

    try {
      unFilterSubCategories = await productRequest.getProductCategories(
        subCat: true,
        vendorTypeId:
            (await AuthServices.getCurrentVendor(force: true)).vendorType?.id,
      );
      clearErrors();
    } catch (error) {
      print("subCategories Error ==> $error");
      setError(error);
    }

    setBusyForObject(subCategories, false);
  }

  fetchMenus() async {
    setBusyForObject(menus, true);

    try {
      final response = await vendorRequest.getVendorDetails();
      final vendor = Vendor.fromJson(response["vendor"]);
      menus = vendor.menus;
      clearErrors();
    } catch (error) {
      print("menus Error ==> $error");
      setError(error);
    }

    setBusyForObject(menus, false);
  }

  //
  onImagesSelected(List<File> files) {
    selectedPhotos = files;
    notifyListeners();
  }

  //
  processUpdateProduct() async {
    if (formBuilderKey.currentState!.saveAndValidate()) {
      //
      setBusy(true);

      try {
        Map<String, dynamic> productData = Map.from(
          formBuilderKey.currentState!.value,
        );

        final categoryIds = productData["category_ids"];
        final subCategoryIds = productData["sub_category_ids"];
        final menuIds = productData["menu_ids"];
        //reassing the values
        if (categoryIds == null ||
            (categoryIds is List && categoryIds.isEmpty)) {
          productData["category_ids"] = "[]";
        }
        if (subCategoryIds == null ||
            (subCategoryIds is List && subCategoryIds.isEmpty)) {
          productData["sub_category_ids"] = "[]";
        }
        if (menuIds == null || (menuIds is List && menuIds.isEmpty)) {
          productData["menu_ids"] = "[]";
        }

        //
        productData.addAll({
          "description": product.description,
        });

        final apiResponse = await productRequest.updateDetails(
          product,
          data: productData,
          photos: selectedPhotos,
        );
        //
        //show dialog to present state
        CoolAlert.show(
            context: viewContext,
            type: apiResponse.allGood
                ? CoolAlertType.success
                : CoolAlertType.error,
            title: "Update Product".tr(),
            text: apiResponse.message,
            onConfirmBtnTap: () {
              viewContext.pop();
              if (apiResponse.allGood) {
                viewContext.pop(true);
              }
            });
        clearErrors();
      } catch (error) {
        print("Update product Error ==> $error");
        setError(error);
      }

      setBusy(false);
    }
  }

  void filterSubcategories(List<String?>? categoryIds) {
    categoryIds ??= [];
    subCategories = unFilterSubCategories.where(
      (e) {
        return categoryIds!.contains(e.categoryId.toString());
      },
    ).toList();
    notifyListeners();
  }

  handleDescriptionEdit() async {
    //get the description
    final result = await viewContext.push(
      (context) => CustomTextEditorPage(
        title: "Product Description".tr(),
        content: product.description ?? "",
      ),
    );
    //
    if (result != null) {
      product.description = result;
      notifyListeners();
    }
  }
}
