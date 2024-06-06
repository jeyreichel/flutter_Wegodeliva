import 'package:vendorapp/constants/api.dart';
import 'package:vendorapp/models/api_response.dart';
import 'package:vendorapp/models/user.dart';
import 'package:vendorapp/services/http.service.dart';

class UserRequest extends HttpService {
  //
  Future<List<User>> getUsers({
    String? role,
  }) async {
    final apiResult = await get(
      Api.users,
      queryParameters: {
        "role": role,
      },
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data.map((jsonObject) {
        return User.fromJson(jsonObject);
      }).toList();
    } else {
      throw apiResponse.message;
    }
  }
}
