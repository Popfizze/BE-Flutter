import 'package:json_annotation/json_annotation.dart';

part 'day.g.dart';

@JsonSerializable()
class Day {
  final int rating;
  final DateTime date;
  final String note;
  final bool contractRespected;
  bool valid;

  Day({
    required this.rating,
    required this.date,
    required this.note,
    required this.contractRespected,
    this.valid = true,
  });

  // Getters
  int getRating() => rating;
  DateTime getDate() => date;
  String getNote() => note;
  bool isValid() => valid;
  bool isContractRespected() => contractRespected;

  // Setters (returns new instance for immutability)
  Day copyWith({
    int? rating,
    DateTime? date,
    String? note,
    bool? contractRespected,
    bool? valid,
  }) {
    return Day(
      rating: rating ?? this.rating,
      date: date ?? this.date,
      note: note ?? this.note,
      contractRespected: contractRespected ?? this.contractRespected,
      valid: valid ?? this.valid,
    );
  }

  void changeValid() {
    valid = !valid;
  }

  // JSON serialization
  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);
  Map<String, dynamic> toJson() => _$DayToJson(this);

  @override
  String toString() {
    return 'Day(rating: $rating, date: $date, note: $note, contractRespected: $contractRespected, valid: $valid)';
  }
}
