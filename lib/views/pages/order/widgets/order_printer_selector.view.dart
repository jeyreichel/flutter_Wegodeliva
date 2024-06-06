import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vendorapp/constants/app_strings.dart';
import 'package:vendorapp/extensions/dynamic.dart';
import 'package:vendorapp/models/order.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:vendorapp/utils/ui_spacer.dart';
import 'package:vendorapp/widgets/buttons/custom_button.dart';
import 'package:vendorapp/widgets/custom_list_view.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderPrinterSelector extends StatefulWidget {
  OrderPrinterSelector(this.order, {Key? key}) : super(key: key);
  final Order order;

  @override
  _OrderPrinterSelectorState createState() => _OrderPrinterSelectorState();
}

class _OrderPrinterSelectorState extends State<OrderPrinterSelector> {
  //START ORDER PRINTING STUFFS
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  bool _deviceConnected = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException catch (error) {
      print("Devices search error ==> $error");
    }

    if (!mounted) return;

    try {
      setState(() {
        _devices = devices;
      });
    } catch (error) {
      print("Error ==> $error");
    }
  }

  ///view
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        "Select Printer".tr().text.semiBold.xl2.make(),
        UiSpacer.verticalSpace(),
        //printers
        _devices.isNotEmpty
            ? CustomListView(
                dataSet: _devices,
                itemBuilder: (context, index) {
                  //
                  final currentDevice = _devices[index];
                  return HStack(
                    [
                      VStack(
                        [
                          "${currentDevice.name}".text.make(),
                          "${currentDevice.address}".text.xs.make(),
                        ],
                      ).expand(),
                      (_selectedDevice != null &&
                              currentDevice.address == _selectedDevice?.address)
                          ? Icon(
                              FlutterIcons.check_ant,
                              color: Colors.green,
                            )
                          : UiSpacer.emptySpace(),
                    ],
                  ).py12().px8().onInkTap(() async {
                    await _disconnect();
                    setState(() {
                      _selectedDevice = currentDevice;
                    });
                    _connect();
                  });
                },
                separatorBuilder: (context, index) => UiSpacer.emptySpace(),
              ).expand()
            : ('Ops something went wrong!. Please check that your bluetooth is ON')
                .tr()
                .text
                .xl
                .makeCentered(),

        //
        UiSpacer.verticalSpace(),
        CustomButton(
          title: "Print".tr(),
          onPressed: _deviceConnected
              ? () {
                  _tesPrint();
                }
              : null,
        )
      ],
    ).p20();
  }

//for connecting to selected bluetooth device
  void _connect() {
    if (_selectedDevice == null) {
      context.showToast(msg: 'No device selected.', bgColor: Colors.red);
    } else {
      bluetooth.isConnected.then((bool? isConnected) {
        if (isConnected == null || !isConnected) {
          bluetooth.connect(_selectedDevice!).then((value) {
            setState(() {
              _deviceConnected = value ?? false;
            });
          }).catchError((error) {
            setState(() {
              _deviceConnected = false;
            });
          });
        } else {
          setState(() {
            _deviceConnected = isConnected;
          });
        }
      });
    }
  }

  //disconnect from device
  _disconnect() async {
    if (await bluetooth.isConnected ?? false) {
      await bluetooth.disconnect();
    }
  }

//write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void _tesPrint() async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    bluetooth.isConnected.then((isConnected) {
      if (isConnected != null && isConnected) {
        bluetooth.printNewLine();
        bluetooth.printCustom("${AppStrings.appName}", 3, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printCustom("${widget.order.vendor?.name}", 2, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("${widget.order.vendor?.address}", 1, 1);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("Code", "  ${widget.order.code}", 1);
        bluetooth.printLeftRight(
            "Status", "  ${widget.order.status.allWordsCapitilize()}", 1);
        bluetooth.printLeftRight("Customer", "  ${widget.order.user.name}", 1);
        bluetooth.printNewLine();
        //parcel order
        if (widget.order.isPackageDelivery) {
          //print stops
          widget.order.orderStops?.forEachIndexed((index, orderStop) {
            if (index == 0) {
              bluetooth.printCustom("Pickup Address".tr(), 1, 0);
            } else {
              bluetooth.printCustom("Stop".tr(), 1, 0);
            }
            bluetooth.printCustom("${orderStop.deliveryAddress?.name}", 2, 0);
            // recipient info
            bluetooth.printLeftRight("Name".tr(), "  ${orderStop.name}", 1);
            bluetooth.printLeftRight("Phone".tr(), "  ${orderStop.phone}", 1);
            bluetooth.printLeftRight("Note".tr(), "  ${orderStop.note}", 1);
            bluetooth.printNewLine();
          });

          //
          bluetooth.printNewLine();
          bluetooth.printCustom("Package Details".tr(), 2, 0);
          bluetooth.printLeftRight(
              "Package Type".tr(), "  ${widget.order.packageType?.name}", 1);
          bluetooth.printLeftRight(
              "Width".tr() + "   ", "${widget.order.width} cm", 1);
          bluetooth.printLeftRight(
              "Length".tr() + "   ", "${widget.order.length} cm", 1);
          bluetooth.printLeftRight(
              "Height".tr() + "   ", "${widget.order.height} cm", 1);
          bluetooth.printLeftRight(
              "Weight".tr() + "   ", "${widget.order.weight} kg", 1);
        } else {
          bluetooth.printCustom("Delivery Address".tr(), 1, 0);
          bluetooth.printCustom(
              "${widget.order.deliveryAddress != null ? widget.order.deliveryAddress?.name : 'Customer Pickup'}",
              2,
              0);

          //
          bluetooth.printNewLine();
          bluetooth.printCustom("Products".tr(), 2, 1);
          //products
          for (var orderProduct in widget.order.orderProducts ?? []) {
            //
            bluetooth.printLeftRight(
                "${orderProduct.product.name} x${orderProduct.quantity}",
                "    ${AppStrings.currencySymbol} ${orderProduct.price}"
                    .currencyFormat(),
                1);
            //product options
            if (orderProduct.options != null) {
              bluetooth.printCustom("${orderProduct.options}", 1, 0);
            }
          }
          //
          bluetooth.printNewLine();
          bluetooth.printCustom("Note".tr(), 2, 0);
          bluetooth.printCustom("${widget.order.note}", 1, 0);
        }
        bluetooth.printNewLine();
        bluetooth.printLeftRight(
          "Subtotal".tr(),
          "  ${AppStrings.currencySymbol} ${widget.order.subTotal}"
              .currencyFormat(),
          1,
        );
        bluetooth.printLeftRight(
          "Discount".tr(),
          "  ${AppStrings.currencySymbol} ${widget.order.discount}"
              .currencyFormat(),
          1,
        );
        bluetooth.printLeftRight(
          "Delivery Fee".tr(),
          "  ${AppStrings.currencySymbol} ${widget.order.deliveryFee}"
              .currencyFormat(),
          1,
        );
        bluetooth.printLeftRight(
          "Tax".tr(),
          "  ${AppStrings.currencySymbol} ${widget.order.tax}".currencyFormat(),
          1,
        );
        bluetooth.printLeftRight(
          "Driver Tip".tr(),
          "  ${AppStrings.currencySymbol} ${widget.order.tip != null ? widget.order.tip : '0.00'}"
              .currencyFormat(),
          1,
        );
        bluetooth.printNewLine();
        bluetooth.printLeftRight(
          "Total".tr(),
          "  ${AppStrings.currencySymbol} ${widget.order.total}"
              .currencyFormat(),
          1,
        );
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printCustom("${widget.order.code}", 3, 1);
        bluetooth.printNewLine();
        bluetooth.paperCut();
        bluetooth.printNewLine();
      }
    });
  }
}
