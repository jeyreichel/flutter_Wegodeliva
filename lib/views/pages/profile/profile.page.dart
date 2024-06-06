import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vendorapp/constants/app_strings.dart';
import 'package:vendorapp/extensions/dynamic.dart';
import 'package:vendorapp/utils/ui_spacer.dart';
import 'package:vendorapp/view_models/profile.vm.dart';
import 'package:vendorapp/widgets/base.page.dart';
import 'package:vendorapp/widgets/cards/profile.card.dart';
import 'package:vendorapp/widgets/menu_item.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(context),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          return BasePage(
            body: VStack(
              [
                //
                "Settings".tr().text.xl2.semiBold.make(),
                "Profile & App Settings".tr().text.lg.light.make(),

                //profile card
                ProfileCard(model).py12(),
                UiSpacer.vSpace(20),

                //menu
                VxBox(
                  child: VStack(
                    [
                      //
                      MenuItem(
                        title: "Notifications".tr(),
                        onPressed: model.openNotification,
                      ),

                      //
                      MenuItem(
                        title: "Rate & Review".tr(),
                        onPressed: model.openReviewApp,
                      ),
                      MenuItem(
                        title: "Faqs".tr(),
                        onPressed: model.openFaqs,
                      ),
                      //
                      MenuItem(
                        title: "Verison".tr(),
                        suffix: model.appVersionInfo.text.make(),
                      ),

                      //
                      MenuItem(
                        title: "Privacy Policy".tr(),
                        onPressed: model.openPrivacyPolicy,
                      ),
                      //
                      MenuItem(
                        title: "Contact Us".tr(),
                        onPressed: model.openContactUs,
                      ),
                      MenuItem(
                        title: "Live support".tr(),
                        onPressed: model.openLivesupport,
                      ),
                      //
                      MenuItem(
                        title: "Language".tr(),
                        divider: false,
                        suffix: Icon(
                          FlutterIcons.language_ent,
                        ),
                        onPressed: model.changeLanguage,
                      ),
                    ],
                  ),
                )
                    // .border(color: Theme.of(context).cardColor)
                    // .color(Theme.of(context).cardColor)
                    .color(Theme.of(context).colorScheme.background)
                    .outerShadow
                    .withRounded(value: 5)
                    .make(),

                //
                "Copyright ©%s %s all right reserved"
                    .tr()
                    .fill([
                      "${DateTime.now().year}",
                      AppStrings.companyName,
                    ])
                    .text
                    .center
                    .sm
                    .makeCentered()
                    .py20(),
              ],
            ).p20().scrollVertical(),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
