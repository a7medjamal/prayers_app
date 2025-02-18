import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prayers_app/widgets/day_prayers.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Surabaya',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
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
      body: Expanded(
        child: Padding(
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
                              'Dhuhur in',
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
                              '2 Hours 4 Minutes',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
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
              PrayerCard(text: 'Imsak'),
              SizedBox(height: 16),
              PrayerCard(text: 'Fajr'),
              SizedBox(height: 16),
              PrayerCard(text: 'Sunrise'),
              SizedBox(height: 16),
              PrayerCard(text: 'Dhuhur'),
              SizedBox(height: 16),
              PrayerCard(text: 'Asr'),
              SizedBox(height: 16),
              PrayerCard(text: 'Maghrib'),
              SizedBox(height: 16),
              PrayerCard(text: 'Isha'),
            ],
          ),
        ),
      ),
    );
  }
}
