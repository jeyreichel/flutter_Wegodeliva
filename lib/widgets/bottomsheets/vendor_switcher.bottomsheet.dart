import 'package:flutter/material.dart';
import 'package:vendorapp/utils/ui_spacer.dart';
import 'package:vendorapp/utils/utils.dart';
import 'package:vendorapp/view_models/vendor_switcher.vm.dart';
import 'package:vendorapp/widgets/custom_image.view.dart';
import 'package:vendorapp/widgets/custom_list_view.dart';
import 'package:vendorapp/widgets/states/loading_indicator.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorSwitcherBottomSheetView extends StatefulWidget {
  const VendorSwitcherBottomSheetView({Key? key}) : super(key: key);
  @override
  _VendorSwitcherBottomSheetViewState createState() =>
      _VendorSwitcherBottomSheetViewState();
}

class _VendorSwitcherBottomSheetViewState
    extends State<VendorSwitcherBottomSheetView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorSwitcherBottomSheetViewModel>.reactive(
      viewModelBuilder: () => VendorSwitcherBottomSheetViewModel(),
      onViewModelReady: (viewModel) => viewModel.fetchMyVendors(),
      builder: (
        BuildContext context,
        VendorSwitcherBottomSheetViewModel model,
        Widget? child,
      ) {
        return Scaffold(
          body: VStack(
            [
              //
              VStack(
                [
                  "List of vendors".tr().text.xl2.semiBold.make(),
                  "Please select a vendor to switch to".tr().text.make(),
                ],
              ).p(12),
              UiSpacer.divider(),
              CustomListView(
                dataSet: model.vendors,
                isLoading: model.busy(model.vendors),
                itemBuilder: (context, index) {
                  final vendor = model.vendors[index];
                  return AbsorbPointer(
                    absorbing: model.isBusy,
                    child: LoadingIndicator(
                      loading: model.busy(vendor.id),
                      child: ListTile(
                        onTap: () {
                          model.switchVendor(vendor);
                        },
                        leading: CustomImage(
                          imageUrl: vendor.logo,
                          width: 30,
                          height: 30,
                        ),
                        title: "${vendor.name}".text.make(),
                        subtitle: "${vendor.address}"
                            .text
                            .ellipsis
                            .maxLines(1)
                            .make(),
                        trailing: Icon(
                          Utils.isArabic
                              ? Icons.chevron_left
                              : Icons.chevron_right,
                          color: context.theme.primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ).expand(),
            ],
          ),
        );
      },
    );
  }
}
