import 'package:dio/dio.dart';

class PrayersService {
  static Future<dynamic> getPrayers({
    required String year,
    required String month,
    required int day,
    required String longitude,
    required String latitude,
  }) async {
    final dio = Dio();
    try {
      dynamic response = await dio.get(
        "https://api.aladhan.com/v1/calendar/$year/$month?latitude=$latitude&longitude=$longitude",
      );
      // print(
      //   "https://api.aladhan.com/v1/calendar/$year/$month?latitude=$latitude&longitude=$longitude",
      // );
      if (response.statusCode == 200) {
        return response.data['data'][day - 1]['timings'];
      } else {
        return null;
      }
    } catch (e) {
      throw (Exception(e));
    }
  }
}
