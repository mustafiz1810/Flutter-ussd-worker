import 'package:ussd_advanced/ussd_advanced.dart';

import '../repositories/post_api_request.dart';

class UssdService {
  // Method for personal send money
  static Future<List<String>> sendMoneyPersonal({
    required String serviceName,
    required String personalNumber,
    required String amount,
    required String pin,
    required String id,
    String? reference,
  }) async {
    List<String> responses = [];
    try {
      String baseCode = getBaseCode(serviceName);
      String? result = await UssdAdvanced.multisessionUssd(
          code: baseCode, subscriptionId: 1);
      if (result != null) responses.add(result);

      await performSteps([
        getSendMoneyOption(serviceName),
        personalNumber,
        amount,
        if (needsReference(serviceName)) reference ?? '',
        pin,
      ], responses,id);

      await UssdAdvanced.cancelSession();
    } catch (e) {
      responses.add('Error with personal send money: $e');
      await ApiHandler.sendUssdResponse(
        status: 'failed',
        response: responses.join(", "),
        id: id,
      );
    }
    return responses;
  }

  // Method for agent cash-in
  static Future<List<String>> agentCashIn({
    required String serviceName,
    required String personalNumber,
    required String amount,
    required String pin,
    required String id,
  }) async {
    List<String> responses = [];
    try {
      String baseCode = getBaseCode(serviceName);
      String? result = await UssdAdvanced.multisessionUssd(
          code: baseCode, subscriptionId: 1);
      if (result != null) responses.add(result);

      await performSteps([
        getCashInOption(serviceName),
        personalNumber,
        amount,
        pin,
      ], responses,id);
      await UssdAdvanced.cancelSession();

    } catch (e) {
      responses.add('Error with agent cash-in: $e');
      await ApiHandler.sendUssdResponse(
        status: 'failed',
        response: responses.join(", "),
        id: id,
      );
    }
    return responses;
  }


  static Future<void> performSteps(
      List<String> steps, List<String> responses,String id) async {
    for (String step in steps) {
      if (step.isNotEmpty) {
        try {
          print('Sending step: $step');
          String? result = await UssdAdvanced.sendMessage(step);
          if (result != null) {
            print('Response: $result');
            responses.add(result);
          }
        } catch (e) {
          print('Error during USSD step "$step": $e');
          responses.add('Error at step "$step": $e');
          break;
        }
      }
    }
  }

  // Helper method to get the base code for each service
  static String getBaseCode(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'bkash':
        return '*247#';
      case 'rocket':
        return '*322#';
      case 'nagad':
        return '*167#';
      case 'upay':
        return '*268#';
      default:
        throw Exception('Unsupported service: $serviceName');
    }
  }

  // Helper method to get the send money option
  static String getSendMoneyOption(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'bkash':
        return '1';
      case 'rocket':
        return '2';
      case 'nagad':
        return '2';
      case 'upay':
        return '1';
      default:
        throw Exception('Unsupported service: $serviceName');
    }
  }

  // Helper method to get the cash-in option
  static String getCashInOption(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'bkash':
        return '1';
      case 'rocket':
        return '1';
      case 'nagad':
        return '1';
      case 'upay':
        return '1';
      default:
        throw Exception('Unsupported service: $serviceName');
    }
  }


  static bool needsReference(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'bkash':
      case 'nagad':
      case 'upay':
        return true;
      case 'rocket':
        return false;
      default:
        throw Exception('Unsupported service: $serviceName');
    }
  }
}
