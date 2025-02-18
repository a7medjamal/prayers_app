import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prayers_app/views/prayers_view.dart';

void main() {
  runApp(const PrayersApp());
}

class PrayersApp extends StatefulWidget {
  const PrayersApp({super.key});

  @override
  State<PrayersApp> createState() => _PrayersAppState();
}

class _PrayersAppState extends State<PrayersApp> {
  bool hasPermission = false;

  Future getPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        hasPermission = true;
      } else {
        Permission.location.request().then((value) {
          setState(() {
            hasPermission = (value == PermissionStatus.granted);
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Montserrat',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
        ),
      ),
      home: FutureBuilder(
        builder: (context, snapshot) {
          if (hasPermission) {
            return const HomeView();
          } else {
            return const Scaffold(
              backgroundColor: Color.fromARGB(255, 48, 48, 48),
            );
          }
        },
        future: getPermission(),
      ),
    );
  }
}
