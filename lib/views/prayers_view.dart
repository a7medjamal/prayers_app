// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prayers_app/services/prayer_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:prayers_app/widgets/day_prayers.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<dynamic> prayerTimes;
  bool hasLocationPermission = false;
  String nextPrayerName = '';
  String formattedDate = '';
  String cityName = 'Loading...';
  String remainingHours = '00', remainingMinutes = '00';
  DateTime? nextPrayerTime;

  @override
  void initState() {
    super.initState();
    _getCityLocation();
    formattedDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
  }

  Future<void> _getCityLocation() async {
    Position position;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        hasLocationPermission = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          hasLocationPermission = false;
        });
        return;
      }
    }
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    String latitude = position.latitude.toString();
    String longitude = position.longitude.toString();
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    setState(() {
      cityName = placemarks.first.locality ?? 'Unknown City';
    });
    String year = DateTime.now().year.toString();
    String month = DateTime.now().month.toString();
    int day = DateTime.now().day;
    prayerTimes = PrayersService.getPrayers(
      year: year,
      month: month,
      day: day,
      latitude: latitude,
      longitude: longitude,
    );
    setState(() {
      hasLocationPermission = true;
    });
  }

  void getNextPrayer(Map<String, dynamic> prayers) {
    DateTime now = DateTime.now();
    for (var element in prayers.entries) {
      if (element.key == 'Imsak' || element.key == 'Sunrise') {
        continue;
      }
      DateTime prayerTime = _convertToDateTime(element.value);
      if (prayerTime.isAfter(now)) {
        setState(() {
          nextPrayerName = element.key;
          nextPrayerTime = prayerTime;
        });
        getRemainingTime();
        break;
      }
    }
  }

  void getRemainingTime() {
    if (nextPrayerTime == null) {
      Duration remainingDuration = nextPrayerTime!.difference(DateTime.now());
      setState(() {
        remainingHours = remainingDuration.inHours.toString();
        remainingMinutes =
            (remainingDuration.inMinutes - (remainingDuration.inHours * 60))
                .toString();
      });
    }
  }

  DateTime _convertToDateTime(String time) {
    try {
      List<String> timeParts = time.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      return DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        hour,
        minute,
      );
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              cityName,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            Text(
              formattedDate,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: SvgPicture.asset('assets/images/drawer_icon.svg'),
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: prayerTimes,
        builder: (context, snapshot) {
          if (!hasLocationPermission) {
            return Center(child: Text('Location permission not granted'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          } else {
            var prayers = snapshot.data;

            if (nextPrayerTime == null) getNextPrayer(prayers);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 340,
                        height: 122,
                        decoration: BoxDecoration(
                          color: Color(0xffBBBBBB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Center(
                                child: Text(
                                  '$nextPrayerName in',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: Text(
                                  '$remainingHours : $remainingMinutes',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  PrayerCard(text: 'Imsak', text2: prayers['Imsak']),
                  SizedBox(height: 16),
                  PrayerCard(text: 'Fajr', text2: prayers['Fajr']),
                  SizedBox(height: 16),
                  PrayerCard(text: 'Sunrise', text2: prayers['Sunrise']),
                  SizedBox(height: 16),
                  PrayerCard(text: 'Dhuhur', text2: prayers['Dhuhr']),
                  SizedBox(height: 16),
                  PrayerCard(text: 'Asr', text2: prayers['Asr']),
                  SizedBox(height: 16),
                  PrayerCard(text: 'Maghrib', text2: prayers['Maghrib']),
                  SizedBox(height: 16),
                  PrayerCard(text: 'Isha', text2: prayers['Isha']),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
