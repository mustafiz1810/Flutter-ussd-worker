import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../helpers/server_reg_helper.dart';
import '../helpers/sharedvalue_helper.dart';
import '../repositories/get_api_request.dart';
import '../repositories/post_api_request.dart';
import '../services/ussd_service.dart';
import '../utils/toast_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _sim1BkashPinController = TextEditingController();
  final TextEditingController _sim1NagadPinController = TextEditingController();
  final TextEditingController _sim1RocketPinController = TextEditingController();
  final TextEditingController _sim1UpayPinController = TextEditingController();
  bool _isServerSelected = false;
  bool _isBkashSelected = false;
  bool _isNagadSelected = false;
  bool _isRocketSelected = false;
  bool _isUpaySelected = false;
  bool _isBkashAgentSelected = false;
  bool _isNagadAgentSelected = false;
  bool _isRocketAgentSelected = false;
  bool _isUpayAgentSelected = false;
  var _requestDetails = null;
  Timer? _fetchTimer;
  bool _isBkashPinObscure = true;
  bool _isNagadPinObscure = true;
  bool _isRocketPinObscure = true;
  bool _isUpayPinObscure = true;
  bool _isFetchingData = false;

  @override
  void initState() {
    super.initState();
    _loadInitialValues();
    _checkAccessibilityPermission();
  }
  @override
  void dispose() {
    _fetchTimer?.cancel(); // Cancel timer when the widget is disposed
    super.dispose();
  }

  void _toggleServer(bool isEnabled) {
    setState(() {
      _isServerSelected = isEnabled;
    });

    if (isEnabled) {
      print("start");
      fetchData();
      _fetchTimer = Timer.periodic(const Duration(seconds: 60), (Timer timer) {
        fetchData();
      });
    } else {
      _fetchTimer?.cancel();
    }
  }




  Future<void> _loadInitialValues() async {
    await Future.wait(ServerHelper().loadServerData());
    setState(() {
      _sim1BkashPinController.text = sim1_bkash_pin.$;
      _sim1NagadPinController.text = sim1_nagad_pin.$;
      _sim1RocketPinController.text = sim1_rocket_pin.$;
      _sim1UpayPinController.text = sim1_upay_pin.$;
      _isBkashSelected = bkash_personal_service.$;
      _isNagadSelected = nagad_personal_service.$;
      _isRocketSelected = rocket_personal_service.$;
      _isUpaySelected = upay_personal_service.$;
      _isBkashAgentSelected = bkash_agent_service.$;
      _isNagadAgentSelected = nagad_agent_service.$;
      _isRocketAgentSelected = rocket_agent_service.$;
      _isUpayAgentSelected = upay_agent_service.$;
    });
  }

  Future<void> _checkAccessibilityPermission() async {
    await FlutterAccessibilityService.requestAccessibilityPermission();
    PermissionStatus callPermissionStatus = await Permission.phone.status;
    if (!callPermissionStatus.isGranted) {
      PermissionStatus status = await Permission.phone.request();
      if (status.isGranted) {
        print("Phone call permission granted");
      } else {
        print("Phone call permission denied");
        ToastUtils.showPhonePermissionDeniedToast(context);
      }
    } else {
      print("Phone call permission already granted");
    }
  }

  Future<void> fetchData() async {
    setState(() {
      _isFetchingData = true;
    });

    try {
      var requestResponse = await GetUssdRepository().getSingleRequestDetails();

      _requestDetails = requestResponse.data;
      if (_requestDetails != null) {
        String serviceName = _requestDetails.mbName;
        String personalNumber = _requestDetails.mobileNumber;
        String reference = _requestDetails.reference;
        String amount = _requestDetails.amount.toString();
        String id = _requestDetails.id.toString();
        // await ApiHandler.sendUssdResponse(
        //   status: 'success',
        //   response: "send instruction",
        //   id: id,
        // );
        List<String> responses = await _sendMultiSessionRequestWithDetails(
          serviceName: serviceName,
          personalNumber: personalNumber,
          reference: reference,
          amount: amount,
          id: id,
        );
        print('Response after USSD session: ${responses.join("\n")}');
      }
    } catch (e) {
      print("Error during fetchData: $e");
    } finally {
      setState(() {
        _isFetchingData = false;
      });
    }
  }


  Future<List<String>> _sendMultiSessionRequestWithDetails({
    required String serviceName,
    required String personalNumber,
    required String reference,
    required String amount,
    required String id,
  }) async {
    String? pin;
    bool isAgent;
    bool isPersonal;

    switch (serviceName.toLowerCase()) {
      case 'bkash':
        isAgent = bkash_agent_service.$;
        isPersonal = bkash_personal_service.$;
        pin = sim1_bkash_pin.$;
        break;
      case 'nagad':
        isAgent = nagad_agent_service.$;
        isPersonal = nagad_personal_service.$;
        pin = sim1_nagad_pin.$;
        break;
      case 'rocket':
        isAgent = rocket_agent_service.$;
        isPersonal = rocket_personal_service.$;
        pin = sim1_rocket_pin.$;
        break;
      case 'upay':
        isAgent = upay_agent_service.$;
        isPersonal = upay_personal_service.$;
        pin = sim1_upay_pin.$;
        break;
      default:
        return ['Unsupported service: $serviceName'];
    }

    try {
      List<String> responses = [];
      if (isAgent) {
        print("Initiating agent cash-in for $serviceName...");
        responses = await UssdService.agentCashIn(
          serviceName: serviceName,
          personalNumber: personalNumber,
          amount: amount,
          pin: pin!,
          id: id,
        );
      } else if (isPersonal) {
        print("Initiating personal send money for $serviceName...");
        responses = await UssdService.sendMoneyPersonal(
          serviceName: serviceName,
          personalNumber: personalNumber,
          amount: amount,
          pin: pin!,
          reference: reference,
          id: id,
        );
      }
      return responses;

    } catch (e) {
      print("Error during USSD transaction: $e");
      return ['Error during USSD transaction: $e'];
    }
  }





  void _registerServer() {
    ServerHelper().setServerData(
      _sim1BkashPinController.text,
      _sim1NagadPinController.text,
      _sim1RocketPinController.text,
      _sim1UpayPinController.text,
      _isBkashSelected,
      _isNagadSelected,
      _isRocketSelected,
      _isUpaySelected,
      _isBkashAgentSelected,
      _isNagadAgentSelected,
      _isRocketAgentSelected,
      _isUpayAgentSelected,
    );
    ToastUtils.showRegistrationSuccessToast(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SwitchListTile(
              value: _isServerSelected,
              tileColor: Colors.blue.withOpacity(0.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              onChanged: _toggleServer,
              title: const Text('Server'),
            ),
            const SizedBox(height: 10),
            const Text('Register Server', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildPinField(
              controller: _sim1BkashPinController,
              label: 'SIM 1 Bkash PIN',
              isObscure: _isBkashPinObscure,
              onToggle: () {
                setState(() {
                  _isBkashPinObscure = !_isBkashPinObscure;
                });
              },
            ),
            CheckboxListTile(
              value: _isBkashSelected,
              onChanged: (bool? value) {
                setState(() {
                  _isBkashSelected = value!;
                  _isBkashAgentSelected = !value;
                });
              },
              title: const Text('Personal'),
            ),
            CheckboxListTile(
              value: _isBkashAgentSelected,
              onChanged: (bool? value) {
                setState(() {
                  _isBkashAgentSelected = value!;
                  _isBkashSelected = !value;
                });
              },
              title: const Text('Agent'),
            ),
            const SizedBox(height: 20),
            _buildPinField(
              controller: _sim1NagadPinController,
              label: 'SIM 1 Nagad PIN',
              isObscure: _isNagadPinObscure,
              onToggle: () {
                setState(() {
                  _isNagadPinObscure = !_isNagadPinObscure;
                });
              },
            ),
            CheckboxListTile(
              value: _isNagadSelected,
              onChanged: (bool? value) {
                setState(() {
                  _isNagadSelected = value!;
                  _isNagadAgentSelected = !value;
                });
              },
              title: const Text('Personal'),
            ),
            CheckboxListTile(
              value: _isNagadAgentSelected,
              onChanged: (bool? value) {
                setState(() {
                  _isNagadAgentSelected = value!;
                  _isNagadSelected = !value;
                });
              },
              title: const Text('Agent'),
            ),
            const SizedBox(height: 20),
            _buildPinField(
              controller: _sim1RocketPinController,
              label: 'SIM 1 Rocket PIN',
              isObscure: _isRocketPinObscure,
              onToggle: () {
                setState(() {
                  _isRocketPinObscure = !_isRocketPinObscure;
                });
              },
            ),
            CheckboxListTile(
              value: _isRocketSelected,
              onChanged: (bool? value) {
                setState(() {
                  _isRocketSelected = value!;
                  _isRocketAgentSelected = false;
                });
              },
              title: const Text('Personal'),
            ),
            CheckboxListTile(
              value: _isRocketAgentSelected,
              onChanged: (bool? value) {
                setState(() {
                  _isRocketAgentSelected = value!;
                  _isRocketSelected = false;
                });
              },
              title: const Text('Agent'),
            ),
            const SizedBox(height: 20),
            _buildPinField(
              controller: _sim1UpayPinController,
              label: 'SIM 1 Upay PIN',
              isObscure: _isUpayPinObscure,
              onToggle: () {
                setState(() {
                  _isUpayPinObscure = !_isUpayPinObscure;
                });
              },
            ),
            CheckboxListTile(
              value: _isUpaySelected,
              onChanged: (bool? value) {
                setState(() {
                  _isUpaySelected = value!;
                  _isUpayAgentSelected = !value;
                });
              },
              title: const Text('Personal'),
            ),
            CheckboxListTile(
              value: _isUpayAgentSelected,
              onChanged: (bool? value) {
                setState(() {
                  _isUpayAgentSelected = value!;
                  _isUpaySelected = !value;
                });
              },
              title: const Text('Agent'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerServer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Register', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildPinField({
    required TextEditingController controller,
    required String label,
    required bool isObscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
