// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Day _$DayFromJson(Map<String, dynamic> json) => Day(
      rating: (json['rating'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String,
      contractRespected: json['contractRespected'] as bool,
      valid: json['valid'] as bool? ?? true,
    );

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
      'rating': instance.rating,
      'date': instance.date.toIso8601String(),
      'note': instance.note,
      'contractRespected': instance.contractRespected,
      'valid': instance.valid,
    };
