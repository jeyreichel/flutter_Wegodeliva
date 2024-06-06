import 'package:vendorapp/constants/api.dart';
import 'package:vendorapp/models/api_response.dart';
import 'package:vendorapp/models/order.dart';
import 'package:vendorapp/services/auth.service.dart';
import 'package:vendorapp/services/http.service.dart';

class OrderRequest extends HttpService {
  //
  Future<List<Order>> getOrders({
    int page = 1,
    String? status,
    String? type,
  }) async {
    final vendorId = (await AuthServices.getCurrentUser()).vendor_id;

    final apiResult = await get(
      Api.orders,
      queryParameters: {
        "vendor_id": vendorId,
        "page": page,
        "status": status,
      },
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data.map((jsonObject) {
        return Order.fromJson(jsonObject);
      }).toList();
    } else {
      throw apiResponse.message;
    }
  }

  //
  Future<Order> getOrderDetails({required int id}) async {
    final apiResult = await get(Api.orders + "/$id");
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Order.fromJson(apiResponse.body);
    } else {
      throw apiResponse.message;
    }
  }

  //
  Future<Order> updateOrder({
    required int id,
    String status = "delivered",
  }) async {
    final apiResult = await patch(
      Api.orders + "/$id",
      {
        "status": status,
      },
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    print("response ==> ${apiResponse.body}");
    if (apiResponse.allGood) {
      return Order.fromJson(apiResponse.body["order"]);
    } else {
      throw apiResponse.message;
    }
  }

  //
  Future<Order> assignOrderToDriver({
    required int id,
    required int driverId,
    required String status,
  }) async {
    final apiResult = await patch(
      Api.orders + "/$id",
      {
        "status": status,
        "driver_id": driverId,
      },
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Order.fromJson(apiResponse.body["order"]);
    } else {
      throw apiResponse.message;
    }
  }
}
