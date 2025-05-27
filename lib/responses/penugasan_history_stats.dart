// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PenugasanHistoryStats {
  String penugasan_uuid;
  int number_of_visit;
  int duration;
  PenugasanHistoryStats({
    required this.penugasan_uuid,
    required this.number_of_visit,
    required this.duration,
  });

  PenugasanHistoryStats copyWith({
    String? penugasan_uuid,
    int? number_of_visit,
    int? duration,
  }) {
    return PenugasanHistoryStats(
      penugasan_uuid: penugasan_uuid ?? this.penugasan_uuid,
      number_of_visit: number_of_visit ?? this.number_of_visit,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'penugasan_uuid': penugasan_uuid,
      'number_of_visit': number_of_visit,
      'duration': duration,
    };
  }

  factory PenugasanHistoryStats.fromJson(Map<String, dynamic> map) {
    return PenugasanHistoryStats(
      penugasan_uuid: map['penugasan_uuid'] as String,
      number_of_visit: map['number_of_visit'] as int,
      duration: map['duration'] as int,
    );
  }

  @override
  String toString() => 'PenugasanHistoryStats(penugasan_uuid: $penugasan_uuid, number_of_visit: $number_of_visit, duration: $duration)';
}
