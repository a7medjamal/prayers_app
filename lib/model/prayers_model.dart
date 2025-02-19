class PrayersModel {
  String name;
  DateTime time;
  bool isCurrent;

  PrayersModel(
      {required this.name, this.isCurrent = false, required this.time});
}