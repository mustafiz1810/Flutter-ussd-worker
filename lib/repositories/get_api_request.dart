import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../data_models/service_request_response.dart';
import '../data_models/service_single_request_response.dart';


class GetUssdRepository {
  Future<ServiceRequestResponse> getRequestDetails() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/get-request");
    final response = await http.get(url, headers: {
      "Content-Type": 'application/json',
    });
    return serviceRequestResponseFromJson(response.body);
  }
  Future<ServiceSingleRequestResponse> getSingleRequestDetails() async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/get-single-request");

    final response = await http.get(url,headers: {
      "Accept": '*/*',
    });
    return serviceSingleRequestResponseFromJson(response.body);
  }
}
