
import 'package:ussd_advance/helpers/sharedvalue_helper.dart';

class ServerHelper {
  setServerData(bkash_pin,nagad_pin,rocket_pin,upay_pin,bkash_personal,
      nagad_personal,rocket_personal,upay_personal,bkash_agent,nagad_agent,
      rocket_agent,upay_agent) {
    sim1_bkash_pin.$ = bkash_pin;
    sim1_bkash_pin.save();
    sim1_nagad_pin.$ = nagad_pin;
    sim1_nagad_pin.save();
    sim1_rocket_pin.$ = rocket_pin;
    sim1_rocket_pin.save();
    sim1_upay_pin.$ = upay_pin;
    sim1_upay_pin.save();
    bkash_personal_service.$ = bkash_personal;
    bkash_personal_service.save();
    nagad_personal_service.$ = nagad_personal;
    nagad_personal_service.save();
    rocket_personal_service.$ = rocket_personal;
    rocket_personal_service.save();
    upay_personal_service.$ = upay_personal;
    upay_personal_service.save();
    bkash_agent_service.$ = bkash_agent;
    bkash_agent_service.save();
    nagad_agent_service.$ = nagad_agent;
    nagad_agent_service.save();
    rocket_agent_service.$ = rocket_agent;
    rocket_agent_service.save();
    upay_agent_service.$ = upay_agent;
    upay_agent_service.save();
  }
  List<Future> loadServerData() {
    return [
      sim1_bkash_pin.load(),
      sim1_nagad_pin.load(),
      sim1_rocket_pin.load(),
      sim1_upay_pin.load(),
      bkash_personal_service.load(),
      nagad_personal_service.load(),
      rocket_personal_service.load(),
      upay_personal_service.load(),
      bkash_agent_service.load(),
      nagad_agent_service.load(),
      rocket_agent_service.load(),
      upay_agent_service.load(),
    ];
  }


}
