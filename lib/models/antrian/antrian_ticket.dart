// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:my_first/models/antrian/antrian_jadwal.dart';
import 'package:my_first/models/antrian/antrian_service_type.dart';
import 'package:my_first/models/antrian/antrian_status.dart';

class AntrianTicket {
  String? uuid;
  String name;
  String email;
  String no_hp;
  String jadwal;
  String service;
  String? qr_code;
  String? created_at;
  bool is_confirmed;
  int status;
  int on_sesi_order;
  AntrianTicket({
    this.uuid,
    required this.name,
    required this.email,
    required this.no_hp,
    required this.jadwal,
    required this.service,
    this.qr_code,
    this.created_at,
    required this.is_confirmed,
    required this.status,
    required this.on_sesi_order,
  });

  AntrianTicket copyWith({
    String? uuid,
    String? name,
    String? email,
    String? no_hp,
    String? jadwal,
    String? service,
    String? qr_code,
    String? created_at,
    bool? is_confirmed,
    int? status,
    int? on_sesi_order,
  }) {
    return AntrianTicket(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      email: email ?? this.email,
      no_hp: no_hp ?? this.no_hp,
      jadwal: jadwal ?? this.jadwal,
      service: service ?? this.service,
      qr_code: qr_code ?? this.qr_code,
      created_at: created_at ?? this.created_at,
      is_confirmed: is_confirmed ?? this.is_confirmed,
      status: status ?? this.status,
      on_sesi_order: on_sesi_order ?? this.on_sesi_order,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'name': name,
      'email': email,
      'no_hp': no_hp,
      'jadwal': jadwal,
      'service': service,
      'qr_code': qr_code,
      'created_at': created_at,
      'is_confirmed': is_confirmed,
      'status': status,
      'on_sesi_order': on_sesi_order,
    };
  }

  factory AntrianTicket.fromJson(Map<String, dynamic> map) {
    return AntrianTicket(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      name: map['name'] as String,
      email: map['email'] as String,
      no_hp: map['no_hp'] as String,
      jadwal: map['jadwal'] as String,
      service: map['service'] as String,
      qr_code: map['qr_code'] != null ? map['qr_code'] as String : null,
      created_at: map['created_at'] != null ? map['created_at'] as String : null,
      is_confirmed: map['is_confirmed'] as bool,
      status: map['status'] as int,
      on_sesi_order: map['on_sesi_order'] as int,
    );
  }

  @override
  String toString() {
    return 'AntrianTicket(uuid: $uuid, name: $name, email: $email, no_hp: $no_hp, jadwal: $jadwal, service: $service, qr_code: $qr_code, created_at: $created_at, is_confirmed: $is_confirmed, status: $status, on_sesi_order: $on_sesi_order)';
  }

  @override
  bool operator ==(covariant AntrianTicket other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.name == name &&
      other.email == email &&
      other.no_hp == no_hp &&
      other.jadwal == jadwal &&
      other.service == service &&
      other.qr_code == qr_code &&
      other.created_at == created_at &&
      other.is_confirmed == is_confirmed &&
      other.status == status &&
      other.on_sesi_order == on_sesi_order;
  }

}

class AntrianTicketDetails {
  // String? uuid;
  // String name;
  // String email;
  // String no_hp;
  // String jadwal;
  // String service;
  // String? qr_code;
  // String? created_at;
  // bool is_confirmed;
  // int status;
  // int on_sesi_order;

  String? antrian_ticket_uuid;
  String antrian_ticket_name;
  String antrian_ticket_email;
  String antrian_ticket_no_hp;
  AntrianJadwalDetails? jadwal_details;
  AntrianServiceTypeDetails? service_details;
  String? antrian_ticket_qr_code;
  String? antrian_ticket_created_at;
  bool antrian_ticket_is_confirmed;
  AntrianStatusDetails? status_details;
  int antrian_ticket_on_sesi_order;
  AntrianTicketDetails({
    this.antrian_ticket_uuid,
    required this.antrian_ticket_name,
    required this.antrian_ticket_email,
    required this.antrian_ticket_no_hp,
    this.jadwal_details,
    this.service_details,
    this.antrian_ticket_qr_code,
    this.antrian_ticket_created_at,
    required this.antrian_ticket_is_confirmed,
    this.status_details,
    required this.antrian_ticket_on_sesi_order,
  });

  AntrianTicketDetails copyWith({
    String? antrian_ticket_uuid,
    String? antrian_ticket_name,
    String? antrian_ticket_email,
    String? antrian_ticket_no_hp,
    AntrianJadwalDetails? jadwal_details,
    AntrianServiceTypeDetails? service_details,
    String? antrian_ticket_qr_code,
    String? antrian_ticket_created_at,
    bool? antrian_ticket_is_confirmed,
    AntrianStatusDetails? status_details,
    int? antrian_ticket_on_sesi_order,
  }) {
    return AntrianTicketDetails(
      antrian_ticket_uuid: antrian_ticket_uuid ?? this.antrian_ticket_uuid,
      antrian_ticket_name: antrian_ticket_name ?? this.antrian_ticket_name,
      antrian_ticket_email: antrian_ticket_email ?? this.antrian_ticket_email,
      antrian_ticket_no_hp: antrian_ticket_no_hp ?? this.antrian_ticket_no_hp,
      jadwal_details: jadwal_details ?? this.jadwal_details,
      service_details: service_details ?? this.service_details,
      antrian_ticket_qr_code: antrian_ticket_qr_code ?? this.antrian_ticket_qr_code,
      antrian_ticket_created_at: antrian_ticket_created_at ?? this.antrian_ticket_created_at,
      antrian_ticket_is_confirmed: antrian_ticket_is_confirmed ?? this.antrian_ticket_is_confirmed,
      status_details: status_details ?? this.status_details,
      antrian_ticket_on_sesi_order: antrian_ticket_on_sesi_order ?? this.antrian_ticket_on_sesi_order,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'antrian_ticket_uuid': antrian_ticket_uuid,
      'antrian_ticket_name': antrian_ticket_name,
      'antrian_ticket_email': antrian_ticket_email,
      'antrian_ticket_no_hp': antrian_ticket_no_hp,
      'jadwal_details': jadwal_details?.toJson(),
      'service_details': service_details?.toJson(),
      'antrian_ticket_qr_code': antrian_ticket_qr_code,
      'antrian_ticket_created_at': antrian_ticket_created_at,
      'antrian_ticket_is_confirmed': antrian_ticket_is_confirmed,
      'status_details': status_details?.toJson(),
      'antrian_ticket_on_sesi_order': antrian_ticket_on_sesi_order,
    };
  }

  factory AntrianTicketDetails.fromJson(Map<String, dynamic> map) {
    return AntrianTicketDetails(
      antrian_ticket_uuid: map['antrian_ticket_uuid'] != null ? map['antrian_ticket_uuid'] as String : null,
      antrian_ticket_name: map['antrian_ticket_name'] as String,
      antrian_ticket_email: map['antrian_ticket_email'] as String,
      antrian_ticket_no_hp: map['antrian_ticket_no_hp'] as String,
      jadwal_details: map['jadwal_details'] != null ? AntrianJadwalDetails.fromJson(map['jadwal_details'] as Map<String,dynamic>) : null,
      service_details: map['service_details'] != null ? AntrianServiceTypeDetails.fromJson(map['service_details'] as Map<String,dynamic>) : null,
      antrian_ticket_qr_code: map['antrian_ticket_qr_code'] != null ? map['antrian_ticket_qr_code'] as String : null,
      antrian_ticket_created_at: map['antrian_ticket_created_at'] != null ? map['antrian_ticket_created_at'] as String : null,
      antrian_ticket_is_confirmed: map['antrian_ticket_is_confirmed'] as bool,
      status_details: map['status_details'] != null ? AntrianStatusDetails.fromJson(map['status_details'] as Map<String,dynamic>) : null,
      antrian_ticket_on_sesi_order: map['antrian_ticket_on_sesi_order'] as int,
    );
  }

  @override
  String toString() {
    return 'AntrianTicketDetails(antrian_ticket_uuid: $antrian_ticket_uuid, antrian_ticket_name: $antrian_ticket_name, antrian_ticket_email: $antrian_ticket_email, antrian_ticket_no_hp: $antrian_ticket_no_hp, jadwal_details: $jadwal_details, service_details: $service_details, antrian_ticket_qr_code: $antrian_ticket_qr_code, antrian_ticket_created_at: $antrian_ticket_created_at, antrian_ticket_is_confirmed: $antrian_ticket_is_confirmed, status_details: $status_details, antrian_ticket_on_sesi_order: $antrian_ticket_on_sesi_order)';
  }

  @override
  bool operator ==(covariant AntrianTicketDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.antrian_ticket_uuid == antrian_ticket_uuid &&
      other.antrian_ticket_name == antrian_ticket_name &&
      other.antrian_ticket_email == antrian_ticket_email &&
      other.antrian_ticket_no_hp == antrian_ticket_no_hp &&
      other.jadwal_details == jadwal_details &&
      other.service_details == service_details &&
      other.antrian_ticket_qr_code == antrian_ticket_qr_code &&
      other.antrian_ticket_created_at == antrian_ticket_created_at &&
      other.antrian_ticket_is_confirmed == antrian_ticket_is_confirmed &&
      other.status_details == status_details &&
      other.antrian_ticket_on_sesi_order == antrian_ticket_on_sesi_order;
  }

}
