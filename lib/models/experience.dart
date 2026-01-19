import 'package:json_annotation/json_annotation.dart';
import 'day.dart';

part 'experience.g.dart';

@JsonSerializable(explicitToJson: true)
class Experience {
  String title;
  DateTime startDate;
  DateTime endDate;
  String contract;
  List<Day> days;

  Experience({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.contract,
    List<Day>? days,
  }) : days = days ?? [];

  // Getters
  String getTitle() => title;
  DateTime getStartDate() => startDate;
  DateTime getEndDate() => endDate;
  String getContract() => contract;
  List<Day> getDays() => days;

  // Setters
  void setTitle(String newTitle) {
    title = newTitle;
  }

  void setStartDate(DateTime newDate) {
    startDate = newDate;
  }

  void setEndDate(DateTime newDate) {
    endDate = newDate;
  }

  void setContract(String newContract) {
    contract = newContract;
  }

  // Rate a day
  void rateDay(int rating, DateTime today, String note, bool contractRespected) {
    final newDay = Day(
      rating: rating,
      date: today,
      note: note,
      contractRespected: contractRespected,
    );
    days.add(newDay);
  }

  // Calculate duration in days
  int getDuration() {
    return endDate.difference(startDate).inDays;
  }

  // Calculate average rating
  double getMean() {
    if (days.isEmpty) return 0.0;
    final validDays = days.where((day) => day.valid).toList();
    if (validDays.isEmpty) return 0.0;

    final sum = validDays.fold<int>(0, (sum, day) => sum + day.rating);
    return sum / validDays.length;
  }

  // copyWith for immutability pattern
  Experience copyWith({
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    String? contract,
    List<Day>? days,
  }) {
    return Experience(
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      contract: contract ?? this.contract,
      days: days ?? this.days,
    );
  }

  // JSON serialization
  factory Experience.fromJson(Map<String, dynamic> json) => _$ExperienceFromJson(json);
  Map<String, dynamic> toJson() => _$ExperienceToJson(this);

  @override
  String toString() {
    return 'Experience(title: $title, startDate: $startDate, endDate: $endDate, contract: $contract, days: ${days.length})';
  }
}
