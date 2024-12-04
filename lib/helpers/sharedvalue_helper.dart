import 'package:shared_value/shared_value.dart';

import '../app_config.dart';

final SharedValue<bool> is_logged_in = SharedValue(
  value: false, // initial value
  key: "is_logged_in", // disk storage key for shared_preferences
);

final SharedValue<String> access_token = SharedValue(
  value: "", // initial value
  key: "access_token", // disk storage key for shared_preferences
);

final SharedValue<String> sim1_pin = SharedValue(
  value: "", // initial value
  key: "sim1_pin", // disk storage key for shared_preferences
);
final SharedValue<String> sim1_bkash_pin = SharedValue(
  value: "", // initial value
  key: "sim1_bkash_pin", // disk storage key for shared_preferences
);
final SharedValue<String> sim1_nagad_pin = SharedValue(
  value: "", // initial value
  key: "sim1_nagad_pin", // disk storage key for shared_preferences
);
final SharedValue<String> sim1_rocket_pin = SharedValue(
  value: "", // initial value
  key: "sim1_rocket_pin", // disk storage key for shared_preferences
);
final SharedValue<String> sim1_upay_pin = SharedValue(
  value: "", // initial value
  key: "sim1_upay_pin", // disk storage key for shared_preferences
);
final SharedValue<String> service = SharedValue(
  value: "", // initial value
  key: "service", // disk storage key for shared_preferences
);
final SharedValue<bool> bkash_personal_service = SharedValue(
  value: false, // initial value
  key: "bkash_personal_service", // disk storage key for shared_preferences
);
final SharedValue<bool> nagad_personal_service = SharedValue(
  value: false, // initial value
  key: "nagad_personal_service", // disk storage key for shared_preferences
);
final SharedValue<bool> rocket_personal_service = SharedValue(
  value: false, // initial value
  key: "rocket_personal_service", // disk storage key for shared_preferences
);
final SharedValue<bool> upay_personal_service = SharedValue(
  value: false, // initial value
  key: "upay_personal_service", // disk storage key for shared_preferences
);
final SharedValue<bool> bkash_agent_service = SharedValue(
  value: false, // initial value
  key: "bkash_agent_service", // disk storage key for shared_preferences
);
final SharedValue<bool> nagad_agent_service = SharedValue(
  value: false, // initial value
  key: "nagad_agent_service", // disk storage key for shared_preferences
);
final SharedValue<bool> rocket_agent_service = SharedValue(
  value: false, // initial value
  key: "rocket_agent_service", // disk storage key for shared_preferences
);
final SharedValue<bool> upay_agent_service = SharedValue(
  value: false, // initial value
  key: "upay_agent_service", // disk storage key for shared_preferences
);