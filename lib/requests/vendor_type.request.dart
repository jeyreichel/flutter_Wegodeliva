import 'package:vendorapp/constants/api.dart';
import 'package:vendorapp/models/api_response.dart';
import 'package:vendorapp/models/vendor_type.dart';
import 'package:vendorapp/services/http.service.dart';

class VendorTypeRequest extends HttpService {
  //
  Future<List<VendorType>> index() async {
    final apiResult = await get(Api.vendorTypes);
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.body as List) .map((e) => VendorType.fromJson(e)).toList();
    }

    throw apiResponse.message;
  }
}
