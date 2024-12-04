// main.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_value/shared_value.dart';
import 'package:toastification/toastification.dart';
import 'package:ussd_advance/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(
    SharedValue.wrapApp(
      const MyApp(),
    ),
  );
}


@pragma('vm:entry-point')
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      initialNotificationTitle: "Background Service",
      initialNotificationContent: "Running in the background",
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      autoStart: true,
    ),
  );

  service.startService();
}

void onStart(ServiceInstance service) {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
      print("Background service has been stopped.");
    });

    // Schedule periodic execution
    // Timer.periodic(const Duration(minutes: 1), (timer) async {
    //   // Await the Future to get the actual boolean value
    //   bool isForeground = await service.isForegroundService();
    //
    //   if (isForeground) {
    //     await backgroundServiceHelper.fetchData();
    //     print("Background service: Data fetch completed.");
    //   }
    // });
  }
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Multi-Page App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}
