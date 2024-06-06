import 'dart:io';

import 'package:dio/dio.dart';
import 'package:vendorapp/constants/api.dart';
import 'package:vendorapp/models/api_response.dart';
import 'package:vendorapp/models/vendor.dart';
import 'package:vendorapp/services/auth.service.dart';
import 'package:vendorapp/services/http.service.dart';

class VendorRequest extends HttpService {
  //
  Future<dynamic> getVendorDetails() async {
    final vendorId = (await AuthServices.getCurrentUser(force: true)).vendor_id;
    final apiResult = await get(
      Api.vendorDetails.replaceFirst("id", vendorId.toString()),
    );

    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.body;
    } else {
      throw apiResponse.message;
    }
  }

  Future<ApiResponse> toggleVendorAvailablity(Vendor vendor) async {
    final apiResult = await post(
      Api.vendorAvailability.replaceFirst(
        "id",
        vendor.id.toString(),
      ),
      {
        "is_open": !vendor.isOpen,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  Future<List<Vendor>> myVendors() async {
    final apiResult = await get(Api.myVendors);
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.body as List)
          .map(
            (e) => Vendor.fromJson(e),
          )
          .toList();
    } else {
      throw apiResponse.message;
    }
  }

  switchVendor(Vendor vendor) async {
    final apiResult = await post(
      Api.switchVendor,
      {
        "vendor_id": vendor.id,
      },
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return;
    } else {
      throw apiResponse.message;
    }
  }

  Future<ApiResponse> submitDocumentsRequest({required List<File> docs}) async {
    FormData formData = FormData.fromMap({});
    for (File file in docs) {
      formData.files.addAll([
        MapEntry("documents[]", await MultipartFile.fromFile(file.path)),
      ]);
    }

    final apiResult = await postCustomFiles(
      Api.documentSubmission,
      null,
      formData: formData,
    );
    return ApiResponse.fromResponse(apiResult);
  }
}
