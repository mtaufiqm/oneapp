import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:my_first/blocs/datetime_helper.dart';
import 'package:my_first/models/antrian/antrian_jadwal.dart';
import 'package:my_first/models/antrian/antrian_service_type.dart';
import 'package:my_first/models/antrian/antrian_sesi.dart';
import 'package:my_first/models/antrian/antrian_status.dart';
import 'package:my_first/models/antrian/antrian_ticket.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';
import 'package:barcode/barcode.dart';
class AntrianTicketRepository extends MyRepository<AntrianTicket> {
  MyConnectionPool conn;

  AntrianTicketRepository(this.conn);

  Future<AntrianTicket> getById(dynamic id) async {
    return this.conn.connectionPool.runTx<AntrianTicket>((tx) async {
      var result = await tx.execute(r"SELECT * FROM antrian_ticket WHERE uuid = $1",parameters: [id as String]);
      if(result.isEmpty){
        throw Exception("There is no Data ${id as String}");
      }
      AntrianTicket object = AntrianTicket.fromJson(result.first.toColumnMap());
      return object;
    });
  }


  //TICKET
  // String? antrian_ticket_uuid;
  // String antrian_ticket_name;
  // String antrian_ticket_email;
  // String antrian_ticket_no_hp;
  // AntrianJadwalDetails? jadwal_details;
  // AntrianServiceTypeDetails? service_details;
  // String? antrian_ticket_qr_code;
  // String? antrian_ticket_created_at;
  // bool antrian_ticket_is_confirmed;
  // AntrianStatusDetails status_details;
  // int antrian_ticket_on_sesi_order;

  //SERVICE
  // String? antrian_service_uuid;
  // String antrian_service_description;

  //JADWAL
  // String? antrian_jadwal_uuid;
  // String antrian_jadwal_date;
  // AntrianSesiDetails? sesi_details;
  // int antrian_jadwal_kuota;

  //SESI
  // String? antrian_sesi_uuid;
  // int antrian_sesi_order;
  // String antrian_sesi_description;
  // String antrian_sesi_tag;
  // String antrian_sesi_code;
  // String antrian_sesi_start;
  // String antrian_sesi_end;

  //STATUS
  // int antrian_sesi_id;
  // String description;

  Future<AntrianTicketDetails> getDetailsById(dynamic id) async {
    return this.conn.connectionPool.runTx<AntrianTicketDetails>((tx) async {
      String query = r'''
SELECT 

att.uuid as antrian_ticket_uuid,
att.name as antrian_ticket_name,
att.email as antrian_ticket_email,
att.no_hp as antrian_ticket_no_hp,
att.qr_code as antrian_ticket_qr_code,
att.created_at as antrian_ticket_created_at,
att.is_confirmed as antrian_ticket_is_confirmed,
att.on_sesi_order as antrian_ticket_on_sesi_order,


ast.uuid as antrian_service_uuid,
ast.description as antrian_service_description,

aj.uuid as antrian_jadwal_uuid,
aj.date as antrian_jadwal_date,
aj.kuota as antrian_jadwal_kuota,

ass.uuid as antrian_sesi_uuid,
ass.order as antrian_sesi_order,
ass.description as antrian_sesi_description,
ass.tag as antrian_sesi_tag,
ass.code as antrian_sesi_code,
ass.sesi_start as antrian_sesi_start,
ass.sesi_end as antrian_sesi_end,


anstat.id as antrian_status_id,
anstat.description as antrian_status_description

FROM antrian_ticket att

LEFT JOIN antrian_service_type ast
ON att.service = ast.uuid

LEFT JOIN antrian_jadwal aj
ON att.jadwal = aj.uuid

LEFT JOIN antrian_sesi ass
ON aj.sesi = ass.uuid

LEFT JOIN antrian_status anstat
ON att.status = anstat.id

WHERE att.uuid = $1
''';
      var result = await tx.execute(query,
      parameters: [id as String]);
      if(result.isEmpty){
        throw Exception("There is no Data ${id as String}");
      }
      Map<String,dynamic> mapResult = result.first.toColumnMap();
      AntrianTicketDetails ticket = AntrianTicketDetails.fromJson(mapResult);
      AntrianServiceTypeDetails service = AntrianServiceTypeDetails.fromJson(mapResult);
      AntrianSesiDetails sesi = AntrianSesiDetails.fromJson(mapResult);
      AntrianJadwalDetails jadwal = AntrianJadwalDetails.fromJson(mapResult);
      AntrianStatusDetails status = AntrianStatusDetails.fromJson(mapResult);

      jadwal.sesi_details = sesi;

      ticket.jadwal_details = jadwal;
      ticket.service_details = service;
      ticket.status_details = status;

      return ticket;
    });
  }

  Future<AntrianTicket> submit(AntrianTicket object) async {
    return this.conn.connectionPool.runTx<AntrianTicket>((tx) async {
      String uuid = Uuid().v1();
      String created_at = DatetimeHelper.getCurrentMakassarTime();
      object.uuid = uuid;
      object.created_at = created_at;
      object.is_confirmed = false;

      //first check quota availability for spesific jadwal;
      String query = 
r'''

SELECT

aj.uuid as antrian_jadwal_uuid,
aj.date as antrian_jadwal_date,
aj.kuota - COALESCE(count(att.jadwal),0) as antrian_jadwal_kuota,

ass.uuid as antrian_sesi_uuid,
ass.order as antrian_sesi_order,
ass.description as antrian_sesi_description,
ass.tag as antrian_sesi_tag,
ass.code as antrian_sesi_code,
ass.sesi_start as antrian_sesi_start,
ass.sesi_end as antrian_sesi_end

FROM antrian_jadwal aj

LEFT JOIN antrian_sesi ass
ON aj.sesi = ass.uuid

LEFT JOIN antrian_ticket att
ON aj.uuid = att.jadwal

WHERE aj.uuid = $1

GROUP BY
aj.uuid,
aj.date,
ass.uuid,
ass.order,
ass.description,
ass.tag,
ass.code,
ass.sesi_start,
ass.sesi_end

ORDER BY aj.date ASC, ass.order ASC
''';

      var result = await tx.execute(query,parameters: [object.jadwal as String]);
      if(result.isEmpty) {
        throw Exception("There is No Antrian Jadwal ${object.jadwal as String}");
      }

      AntrianJadwalDetails jadwalDetails = AntrianJadwalDetails.fromJson(result.first.toColumnMap());
      AntrianSesiDetails sesiDetails = AntrianSesiDetails.fromJson(result.first.toColumnMap());
      jadwalDetails.sesi_details = sesiDetails;

      //if jadwal_kuota not available or less than 0 just throw Exception
      if(jadwalDetails.antrian_jadwal_kuota <= 0) {
        throw Exception("Kuota Pada Jadwal Tersebut Telah Habis!");
      }


      //set on_sesi_order value
      int on_sesi_order = 1;
      var resultMaxOrder = await tx.execute(r"SELECT COALESCE(MAX(att.on_sesi_order),0) as max_value FROM antrian_ticket att WHERE att.jadwal = $1",parameters: [object.jadwal]);
      if(!resultMaxOrder.isEmpty){
        int tempValue = (resultMaxOrder.first.toColumnMap()["max_value"] as int?)??0;
        on_sesi_order = ++tempValue;
      }
      object.on_sesi_order = on_sesi_order;

      //set default status value for submit
      //0: PENDING
      object.status = 0;   

      //generate qr_code in base64
      // var qr_generator = QrCode(4, QrErrorCorrectLevel.L);
      // qr_generator.addData(jsonEncode({
      //   "uuid":object.uuid!,
      //   "jadwal":"${jadwalDetails.antrian_jadwal_date}",
      //   "sesi":"${sesiDetails.antrian_sesi_tag}",
      //   "deskripsi sesi":"${sesiDetails.antrian_sesi_description}"
      // }));
      // var qr_image = QrImage(qr_generator);

      //generate qr_code
      var barcode = Barcode.qrCode(typeNumber: 8);
      String qr_code_data = '''https://api.bpsluwu.id/public/antrian/ticket/item/#1/pdf'''.replaceFirst("#1",uuid);
      String qr_code = barcode.toSvg(qr_code_data);
      object.qr_code = qr_code;

      //second if there is quota, insert new ticket data
      var result2 = await tx.execute(r"INSERT INTO antrian_ticket VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) RETURNING uuid",
      parameters: [
        object.uuid!,
        object.name,
        object.email,
        object.no_hp,
        object.jadwal,
        object.service,
        object.qr_code,
        object.created_at,
        object.is_confirmed,
        object.status,
        object.on_sesi_order
      ]);
      if(result2.isEmpty){
        throw Exception("Failed Create New Ticket!");
      }
      return object;
    });
  }

  //need more implementations
  Future<AntrianTicket> update(dynamic id, AntrianTicket object) async {
    return this.conn.connectionPool.runTx<AntrianTicket>((tx) async {
      return object;
    });
  }

  Future<AntrianTicket> create(AntrianTicket object) async {
    return this.conn.connectionPool.runTx<AntrianTicket>((tx) async {
      String uuid = Uuid().v1();
      String created_at = DatetimeHelper.getCurrentMakassarTime();
      object.uuid = uuid;
      object.created_at = created_at;
      object.is_confirmed = false;
      var result = await tx.execute(r"INSERT INTO antrian_ticket VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)",
      parameters: [
        object.uuid!,
        object.name,
        object.email,
        object.no_hp,
        object.jadwal,
        object.service,
        object.qr_code,
        object.created_at,
        object.is_confirmed,
        object.status,
        object.on_sesi_order
      ]);
      return object;
    });
  }

  Future<List<AntrianJadwalDetalsWithTickets>> readAllTodayGroupBySesi() async {
    return this.conn.connectionPool.runTx<List<AntrianJadwalDetalsWithTickets>>((tx) async {
      String todayDate = DateFormat('yyyy-MM-dd').format(DatetimeHelper.parseMakassarTime(DatetimeHelper.getCurrentMakassarTime()));
      //String todayDate = '2025-07-19';
      String query = 
r'''
SELECT 

att.uuid as antrian_ticket_uuid,
att.name as antrian_ticket_name,
att.email as antrian_ticket_email,
att.no_hp as antrian_ticket_no_hp,
att.qr_code as antrian_ticket_qr_code,
att.created_at as antrian_ticket_created_at,
att.is_confirmed as antrian_ticket_is_confirmed,
att.on_sesi_order as antrian_ticket_on_sesi_order,

ast.uuid as antrian_service_uuid,
ast.description as antrian_service_description,

aj.uuid as antrian_jadwal_uuid,
aj.date as antrian_jadwal_date,
aj.kuota as antrian_jadwal_kuota,

ass.uuid as antrian_sesi_uuid,
ass.order as antrian_sesi_order,
ass.description as antrian_sesi_description,
ass.tag as antrian_sesi_tag,
ass.code as antrian_sesi_code,
ass.sesi_start as antrian_sesi_start,
ass.sesi_end as antrian_sesi_end,

anstat.id as antrian_status_id,
anstat.description as antrian_status_description

FROM antrian_ticket att

LEFT JOIN antrian_service_type ast
ON att.service = ast.uuid

LEFT JOIN antrian_jadwal aj
ON att.jadwal = aj.uuid

LEFT JOIN antrian_sesi ass
ON aj.sesi = ass.uuid

LEFT JOIN antrian_status anstat
ON att.status = anstat.id

WHERE aj.date = $1 AND att.is_confirmed = false AND anstat.id = 0

ORDER BY
ass.order ASC, att.created_at ASC

''';

      List<AntrianJadwalDetalsWithTickets> listObject = [];
      var result = await tx.execute(query,parameters: [todayDate]);
      if(result.isEmpty){
        return listObject;
      }

      Map<String,AntrianJadwalDetalsWithTickets> mapObject = {}; 
      for(var item in result){
        try {
          AntrianTicketDetails ticket = AntrianTicketDetails.fromJson(item.toColumnMap());
          AntrianServiceTypeDetails service = AntrianServiceTypeDetails.fromJson(item.toColumnMap());
          AntrianSesiDetails sesi = AntrianSesiDetails.fromJson(item.toColumnMap());
          AntrianJadwalDetails jadwal = AntrianJadwalDetails.fromJson(item.toColumnMap());
          AntrianStatusDetails status = AntrianStatusDetails.fromJson(item.toColumnMap());

          jadwal.sesi_details = sesi;

          ticket.jadwal_details = jadwal;
          ticket.service_details = service;
          ticket.status_details = status;

          //if jadwal already there
          if(mapObject.containsKey(jadwal.antrian_jadwal_uuid!)){
            mapObject[jadwal.antrian_jadwal_uuid]?.tickets.add(ticket);
            continue;
          }
          //else
          mapObject[jadwal.antrian_jadwal_uuid!] = AntrianJadwalDetalsWithTickets(jadwal: jadwal, tickets: [ticket]);
          continue;
        } catch(err){
          continue;
        }
      }
      return mapObject.values.toList();
    });
  }

  Future<List<AntrianTicket>> readAll() async {
    return this.conn.connectionPool.runTx<List<AntrianTicket>>((tx) async {
      return [];
    });
  }


  //need more implementations
  Future<void> delete(dynamic id) async {
    return;
  }
}