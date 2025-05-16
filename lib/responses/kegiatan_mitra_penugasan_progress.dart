// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';



class KegiatanMitraPenugasanByKegiatanProgress {
  String? kegiatan_uuid;
  String kegiatan_name;
  String kegiatan_desc;
  List<StatusProgress> progress;
  KegiatanMitraPenugasanByKegiatanProgress({
    this.kegiatan_uuid,
    required this.kegiatan_name,
    required this.kegiatan_desc,
    required this.progress,
  });

  KegiatanMitraPenugasanByKegiatanProgress copyWith({
    String? kegiatan_uuid,
    String? kegiatan_name,
    String? kegiatan_desc,
    List<StatusProgress>? progress,
  }) {
    return KegiatanMitraPenugasanByKegiatanProgress(
      kegiatan_uuid: kegiatan_uuid ?? this.kegiatan_uuid,
      kegiatan_name: kegiatan_name ?? this.kegiatan_name,
      kegiatan_desc: kegiatan_desc ?? this.kegiatan_desc,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'kegiatan_uuid': kegiatan_uuid,
      'kegiatan_name': kegiatan_name,
      'kegiatan_desc': kegiatan_desc,
      'progress': progress.map((x) => x.toJson()).toList(),
    };
  }

  factory KegiatanMitraPenugasanByKegiatanProgress.fromJson(Map<String, dynamic> map) {
    return KegiatanMitraPenugasanByKegiatanProgress(
      kegiatan_uuid: map['kegiatan_uuid'] != null ? map['kegiatan_uuid'] as String : null,
      kegiatan_name: map['kegiatan_name'] as String,
      kegiatan_desc: map['kegiatan_desc'] as String,
      progress: List<StatusProgress>.from((map['progress'] as List<dynamic>).map<StatusProgress>((x) => StatusProgress.fromJson(x as Map<String,dynamic>),),),
    );
  }

  @override
  String toString() {
    return 'KegiatanMitraPenugasanByKegiatanProgress(kegiatan_uuid: $kegiatan_uuid, kegiatan_name: $kegiatan_name, kegiatan_desc: $kegiatan_desc, progress: $progress)';
  }

}

class KegiatanMitraPenugasanByMitraProgress {
  String? mitra_id;
  String mitra_name;
  String mitra_username;
  String? kegiatan_uuid;
  String kegiatan_name;
  String kegiatan_desc;
  List<StatusProgress> progress;
  KegiatanMitraPenugasanByMitraProgress({
    this.mitra_id,
    required this.mitra_name,
    required this.mitra_username,
    this.kegiatan_uuid,
    required this.kegiatan_name,
    required this.kegiatan_desc,
    required this.progress,
  });

  KegiatanMitraPenugasanByMitraProgress copyWith({
    String? mitra_id,
    String? mitra_name,
    String? mitra_username,
    String? kegiatan_uuid,
    String? kegiatan_name,
    String? kegiatan_desc,
    List<StatusProgress>? progress,
  }) {
    return KegiatanMitraPenugasanByMitraProgress(
      mitra_id: mitra_id ?? this.mitra_id,
      mitra_name: mitra_name ?? this.mitra_name,
      mitra_username: mitra_username ?? this.mitra_username,
      kegiatan_uuid: kegiatan_uuid ?? this.kegiatan_uuid,
      kegiatan_name: kegiatan_name ?? this.kegiatan_name,
      kegiatan_desc: kegiatan_desc ?? this.kegiatan_desc,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'mitra_id': mitra_id,
      'mitra_name': mitra_name,
      'mitra_username': mitra_username,
      'kegiatan_uuid': kegiatan_uuid,
      'kegiatan_name': kegiatan_name,
      'kegiatan_desc': kegiatan_desc,
      'progress': progress.map((x) => x.toJson()).toList(),
    };
  }

  factory KegiatanMitraPenugasanByMitraProgress.fromJson(Map<String, dynamic> map) {
    return KegiatanMitraPenugasanByMitraProgress(
      mitra_id: map['mitra_id'] != null ? map['mitra_id'] as String : null,
      mitra_name: map['mitra_name'] as String,
      mitra_username: map['mitra_username'] as String,
      kegiatan_uuid: map['kegiatan_uuid'] != null ? map['kegiatan_uuid'] as String : null,
      kegiatan_name: map['kegiatan_name'] as String,
      kegiatan_desc: map['kegiatan_desc'] as String,
      progress: List<StatusProgress>.from((map['progress'] as List<dynamic>).map<StatusProgress>((x) => StatusProgress.fromJson(x as Map<String,dynamic>),),),
    );
  }

  @override
  String toString() {
    return 'KegiatanMitraPenugasanByMitraProgress(mitra_id: $mitra_id, mitra_name: $mitra_name, mitra_username: $mitra_username, kegiatan_uuid: $kegiatan_uuid, kegiatan_name: $kegiatan_name, kegiatan_desc: $kegiatan_desc, progress: $progress)';
  }
}

class KegiatanMitraPenugasanByGroupProgress {
  String? mitra_id;
  String mitra_name;
  String mitra_username;
  String? kegiatan_uuid;
  String kegiatan_name;
  String kegiatan_desc;
  int group_type_id;
  String group;
  String group_desc;
  List<StatusProgress> progress;
  KegiatanMitraPenugasanByGroupProgress({
    this.mitra_id,
    required this.mitra_name,
    required this.mitra_username,
    this.kegiatan_uuid,
    required this.kegiatan_name,
    required this.kegiatan_desc,
    required this.group_type_id,
    required this.group,
    required this.group_desc,
    required this.progress,
  });

  KegiatanMitraPenugasanByGroupProgress copyWith({
    String? mitra_id,
    String? mitra_name,
    String? mitra_username,
    String? kegiatan_uuid,
    String? kegiatan_name,
    String? kegiatan_desc,
    int? group_type_id,
    String? group,
    String? group_desc,
    List<StatusProgress>? progress,
  }) {
    return KegiatanMitraPenugasanByGroupProgress(
      mitra_id: mitra_id ?? this.mitra_id,
      mitra_name: mitra_name ?? this.mitra_name,
      mitra_username: mitra_username ?? this.mitra_username,
      kegiatan_uuid: kegiatan_uuid ?? this.kegiatan_uuid,
      kegiatan_name: kegiatan_name ?? this.kegiatan_name,
      kegiatan_desc: kegiatan_desc ?? this.kegiatan_desc,
      group_type_id: group_type_id ?? this.group_type_id,
      group: group ?? this.group,
      group_desc: group_desc ?? this.group_desc,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'mitra_id': mitra_id,
      'mitra_name': mitra_name,
      'mitra_username': mitra_username,
      'kegiatan_uuid': kegiatan_uuid,
      'kegiatan_name': kegiatan_name,
      'kegiatan_desc': kegiatan_desc,
      'group_type_id': group_type_id,
      'group': group,
      'group_desc': group_desc,
      'progress': progress.map((x) => x.toJson()).toList(),
    };
  }

  factory KegiatanMitraPenugasanByGroupProgress.fromJson(Map<String, dynamic> map) {
    return KegiatanMitraPenugasanByGroupProgress(
      mitra_id: map['mitra_id'] != null ? map['mitra_id'] as String : null,
      mitra_name: map['mitra_name'] as String,
      mitra_username: map['mitra_username'] as String,
      kegiatan_uuid: map['kegiatan_uuid'] != null ? map['kegiatan_uuid'] as String : null,
      kegiatan_name: map['kegiatan_name'] as String,
      kegiatan_desc: map['kegiatan_desc'] as String,
      group_type_id: map['group_type_id'] as int,
      group: map['group'] as String,
      group_desc: map['group_desc'] as String,
      progress: List<StatusProgress>.from((map['progress'] as List<dynamic>).map<StatusProgress>((x) => StatusProgress.fromJson(x as Map<String,dynamic>),),),
    );
  }

  @override
  String toString() {
    return 'KegiatanMitraPenugasanByGroupProgress(mitra_id: $mitra_id, mitra_name: $mitra_name, mitra_username: $mitra_username, kegiatan_uuid: $kegiatan_uuid, kegiatan_name: $kegiatan_name, kegiatan_desc: $kegiatan_desc, group_type_id: $group_type_id, group: $group, group_desc: $group_desc, progress: $progress)';
  }

}

class StatusProgress {
  int status;
  String status_desc;
  int total;
  StatusProgress({
    required this.status,
    required this.status_desc,
    required this.total,
  });

  StatusProgress copyWith({
    int? status,
    String? status_desc,
    int? total,
  }) {
    return StatusProgress(
      status: status ?? this.status,
      status_desc: status_desc ?? this.status_desc,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'status': status,
      'status_desc': status_desc,
      'total': total,
    };
  }

  factory StatusProgress.fromJson(Map<String, dynamic> map) {
    return StatusProgress(
      status: map['status'] as int,
      status_desc: map['status_desc'] as String,
      total: map['total'] as int,
    );
  }

  @override
  String toString() => 'StatusProgress(status: $status, status_desc: $status_desc, total: $total)';
}
