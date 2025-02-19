import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrayerCard extends StatelessWidget {
  final String? text, text2;
  const PrayerCard({super.key, this.text, required this.text2});

  @override
  Widget build(BuildContext context) {
    String formattedTime = _convertTo12Hour(text2 ?? '');

    return Container(
      width: 340,
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xffe5e5e5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text(
                text ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            const Spacer(),
            Text(
              formattedTime,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _convertTo12Hour(String time) {
    try {
      String cleanTime = time.replaceAll(RegExp(r'\(.*\)'), '').trim();
      DateTime parsedTime = DateFormat("HH:mm").parse(cleanTime);
      String formattedTime = DateFormat("hh : mm").format(parsedTime);
      return formattedTime;
    } catch (e) {
      return time;
    }
  }
}
