
import 'package:my_first/models/ickm/survei.dart';

class ResponseAssignmentStructure {
  String? response_assignment_uuid;
  String kegiatan_uuid;
  String kegiatan_name;
  String kegiatan_description;
  String structure_uuid;
  String? penilai_username;
  String? penilai_name;
  String mitra_username;
  String mitra_name;
  String mitra_id;
  List<String> mitra_penugasan_groups;
  String? notes;
  SurveiResponseStructure survei_template;
  ResponseAssignmentStructure({
    this.response_assignment_uuid,
    required this.kegiatan_uuid,
    required this.kegiatan_name,
    required this.kegiatan_description,
    required this.structure_uuid,
    this.penilai_username,
    this.penilai_name,
    required this.mitra_username,
    required this.mitra_name,
    required this.mitra_id,
    required this.mitra_penugasan_groups,
    this.notes,
    required this.survei_template,
  });

  ResponseAssignmentStructure copyWith({
    String? response_assignment_uuid,
    String? kegiatan_uuid,
    String? kegiatan_name,
    String? kegiatan_description,
    String? structure_uuid,
    String? penilai_username,
    String? penilai_name,
    String? mitra_username,
    String? mitra_name,
    String? mitra_id,
    List<String>? mitra_penugasan_groups,
    String? notes,
    SurveiResponseStructure? survei_template,
  }) {
    return ResponseAssignmentStructure(
      response_assignment_uuid: response_assignment_uuid ?? this.response_assignment_uuid,
      kegiatan_uuid: kegiatan_uuid ?? this.kegiatan_uuid,
      kegiatan_name: kegiatan_name ?? this.kegiatan_name,
      kegiatan_description: kegiatan_description ?? this.kegiatan_description,
      structure_uuid: structure_uuid ?? this.structure_uuid,
      penilai_username: penilai_username ?? this.penilai_username,
      penilai_name: penilai_name ?? this.penilai_name,
      mitra_username: mitra_username ?? this.mitra_username,
      mitra_name: mitra_name ?? this.mitra_name,
      mitra_id: mitra_id ?? this.mitra_id,
      mitra_penugasan_groups: mitra_penugasan_groups ?? this.mitra_penugasan_groups,
      notes: notes ?? this.notes,
      survei_template: survei_template ?? this.survei_template,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'response_assignment_uuid': response_assignment_uuid,
      'kegiatan_uuid': kegiatan_uuid,
      'kegiatan_name': kegiatan_name,
      'kegiatan_description': kegiatan_description,
      'structure_uuid': structure_uuid,
      'penilai_username': penilai_username,
      'penilai_name': penilai_name,
      'mitra_username': mitra_username,
      'mitra_name': mitra_name,
      'mitra_id': mitra_id,
      'mitra_penugasan_groups': mitra_penugasan_groups,
      'notes': notes,
      'survei_template': survei_template.toJson(),
    };
  }

  factory ResponseAssignmentStructure.fromJson(Map<String, dynamic> map) {
    return ResponseAssignmentStructure(
      response_assignment_uuid: map['response_assignment_uuid'] != null ? map['response_assignment_uuid'] as String : null,
      kegiatan_uuid: map['kegiatan_uuid'] as String,
      kegiatan_name: map['kegiatan_name'] as String,
      kegiatan_description: map['kegiatan_description'] as String,
      structure_uuid: map['structure_uuid'] as String,
      penilai_username: map['penilai_username'] != null ? map['penilai_username'] as String : null,
      penilai_name: map['penilai_name'] != null ? map['penilai_name'] as String : null,
      mitra_username: map['mitra_username'] as String,
      mitra_name: map['mitra_name'] as String,
      mitra_id: map['mitra_id'] as String,
      mitra_penugasan_groups: List<String>.from((map['mitra_penugasan_groups'] as List<String>)),
      notes: map['notes'] != null ? map['notes'] as String : null,
      survei_template: SurveiResponseStructure.fromJson(map['survei_template'] as Map<String,dynamic>),
    );
  }
  @override
  String toString() {
    return 'ResponseAssignmentStructure(response_assignment_uuid: $response_assignment_uuid, kegiatan_uuid: $kegiatan_uuid, kegiatan_name: $kegiatan_name, kegiatan_description: $kegiatan_description, structure_uuid: $structure_uuid, penilai_username: $penilai_username, penilai_name: $penilai_name, mitra_username: $mitra_username, mitra_name: $mitra_name, mitra_id: $mitra_id, mitra_penugasan_groups: $mitra_penugasan_groups, notes: $notes, survei_template: $survei_template)';
  }

}
