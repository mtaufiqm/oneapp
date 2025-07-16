// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:my_first/models/antrian/antrian_sesi.dart';
import 'package:my_first/models/antrian/antrian_ticket.dart';

class AntrianJadwal {
  String? uuid;
  String date;
  String sesi;
  int kuota;
  AntrianJadwal({
    this.uuid,
    required this.date,
    required this.sesi,
    required this.kuota,
  });

  AntrianJadwal copyWith({
    String? uuid,
    String? date,
    String? sesi,
    int? kuota,
  }) {
    return AntrianJadwal(
      uuid: uuid ?? this.uuid,
      date: date ?? this.date,
      sesi: sesi ?? this.sesi,
      kuota: kuota ?? this.kuota,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'date': date,
      'sesi': sesi,
      'kuota': kuota,
    };
  }

  factory AntrianJadwal.fromJson(Map<String, dynamic> map) {
    return AntrianJadwal(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      date: map['date'] as String,
      sesi: map['sesi'] as String,
      kuota: map['kuota'] as int,
    );
  }

  @override
  String toString() {
    return 'AntrianJadwal(uuid: $uuid, date: $date, sesi: $sesi, kuota: $kuota)';
  }

  @override
  bool operator ==(covariant AntrianJadwal other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.date == date &&
      other.sesi == sesi &&
      other.kuota == kuota;
  }
}

class AntrianJadwalDetails {
  String? antrian_jadwal_uuid;
  String antrian_jadwal_date;
  AntrianSesiDetails? sesi_details;
  int antrian_jadwal_kuota;
  AntrianJadwalDetails({
    this.antrian_jadwal_uuid,
    required this.antrian_jadwal_date,
    this.sesi_details,
    required this.antrian_jadwal_kuota,
  });

  AntrianJadwalDetails copyWith({
    String? antrian_jadwal_uuid,
    String? antrian_jadwal_date,
    AntrianSesiDetails? sesi_details,
    int? antrian_jadwal_kuota,
  }) {
    return AntrianJadwalDetails(
      antrian_jadwal_uuid: antrian_jadwal_uuid ?? this.antrian_jadwal_uuid,
      antrian_jadwal_date: antrian_jadwal_date ?? this.antrian_jadwal_date,
      sesi_details: sesi_details ?? this.sesi_details,
      antrian_jadwal_kuota: antrian_jadwal_kuota ?? this.antrian_jadwal_kuota,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'antrian_jadwal_uuid': antrian_jadwal_uuid,
      'antrian_jadwal_date': antrian_jadwal_date,
      'sesi_details': sesi_details?.toJson(),
      'antrian_jadwal_kuota': antrian_jadwal_kuota,
    };
  }

  factory AntrianJadwalDetails.fromJson(Map<String, dynamic> map) {
    return AntrianJadwalDetails(
      antrian_jadwal_uuid: map['antrian_jadwal_uuid'] != null ? map['antrian_jadwal_uuid'] as String : null,
      antrian_jadwal_date: map['antrian_jadwal_date'] as String,
      sesi_details: map['sesi_details'] != null ? AntrianSesiDetails.fromJson(map['sesi_details'] as Map<String,dynamic>) : null,
      antrian_jadwal_kuota: map['antrian_jadwal_kuota'] as int,
    );
  }
  @override
  String toString() {
    return 'AntrianJadwalDetails(antrian_jadwal_uuid: $antrian_jadwal_uuid, antrian_jadwal_date: $antrian_jadwal_date, sesi_details: $sesi_details, antrian_jadwal_kuota: $antrian_jadwal_kuota)';
  }

  @override
  bool operator ==(covariant AntrianJadwalDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.antrian_jadwal_uuid == antrian_jadwal_uuid &&
      other.antrian_jadwal_date == antrian_jadwal_date &&
      other.sesi_details == sesi_details &&
      other.antrian_jadwal_kuota == antrian_jadwal_kuota;
  }
}

class AntrianJadwalDetalsWithTickets {
  AntrianJadwalDetails jadwal;
  List<AntrianTicketDetails> tickets;
  AntrianJadwalDetalsWithTickets({
    required this.jadwal,
    required this.tickets,
  });

  AntrianJadwalDetalsWithTickets copyWith({
    AntrianJadwalDetails? jadwal,
    List<AntrianTicketDetails>? tickets,
  }) {
    return AntrianJadwalDetalsWithTickets(
      jadwal: jadwal ?? this.jadwal,
      tickets: tickets ?? this.tickets,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'jadwal': jadwal.toJson(),
      'tickets': tickets.map((x) => x.toJson()).toList(),
    };
  }

  factory AntrianJadwalDetalsWithTickets.fromMap(Map<String, dynamic> map) {
    return AntrianJadwalDetalsWithTickets(
      jadwal: AntrianJadwalDetails.fromJson(map['jadwal'] as Map<String,dynamic>),
      tickets: List<AntrianTicketDetails>.from((map['tickets'] as List<dynamic>).map<AntrianTicketDetails>((x) => AntrianTicketDetails.fromJson(x as Map<String,dynamic>))),
    );
  }

  @override
  String toString() => 'AntrianJadwalDetalsWithTickets(jadwal: $jadwal, tickets: $tickets)';

  @override
  bool operator ==(covariant AntrianJadwalDetalsWithTickets other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.jadwal == jadwal &&
      listEquals(other.tickets, tickets);
  }

}
