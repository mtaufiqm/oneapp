//FUTURE CONTINUE THIS FOR BS
import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/models/daerah_tingkat_3.dart';
import 'package:my_first/models/daerah_tingkat_4.dart';
import 'package:my_first/models/daerah_tingkat_5.dart';
import 'package:my_first/repository/daerah_tingkat_3_repository.dart';
import 'package:my_first/repository/daerah_tingkat_4_repository.dart';
import 'package:my_first/repository/daerah_tingkat_5_repository.dart';

Future<String> generateGroupDesc(RequestContext ctx, int group_type_id, String group_code) async {
  try{
    switch(group_type_id){
      //for provinsi
      case 0:
        return "[73] - Prov. Sulawesi Selatan";
      //kabupaten/kota
      case 1:
        return "[7317] - Kab. Luwu";
      //kecamatan
      case 2:
        return await generateDesc2(ctx, group_code);
      //desa/kelurahan
      case 3:
        return await generateDesc3(ctx, group_code);
      //sls
      case 4:
        return await generateDesc4(ctx, group_code);
      //blok_sensus
      case 5:
        return "${group_code}";
      //nks
      case 6:
        return "${group_code}";
      //default
      default: 
        return "${group_code}";
    }
  } catch(e){
    print("Error ${e}");
    throw Exception("Error Generate Description type : ${group_type_id}, code : ${group_code}");
  }
}

//Kecamatan : 7 Digit
Future<String> generateDesc2(RequestContext ctx, String group_code) async {
  DaerahTingkat3Repository dt3_repo = ctx.read<DaerahTingkat3Repository>();
  String cleanedString = group_code.trim();
  if(cleanedString.length != 7){
    throw Exception("Invalid Code Length");
  }
  DaerahTingkat3 daerah = await dt3_repo.getById("${cleanedString}");
  String desc = "[${daerah.id}] - KEC. ${daerah.name}";
  return desc;    
}


//Desa : 10 Digit
Future<String> generateDesc3(RequestContext ctx, String group_code) async {
  DaerahTingkat3Repository dt3_repo = ctx.read<DaerahTingkat3Repository>();
  DaerahTingkat4Repository dt4_repo = ctx.read<DaerahTingkat4Repository>();
  String cleanedString = group_code.trim();
  if(cleanedString.length != 10){
    throw Exception("Invalid Code Length");
  }
  DaerahTingkat3 dt3 = await dt3_repo.getById(cleanedString.substring(0,7));
  DaerahTingkat4 daerah = await dt4_repo.getById("${cleanedString}");
  String desc = "[${daerah.id}] - Kec. ${dt3.name} - Desa/Kel. ${daerah.name}";
  return desc;    
}

//SLS : 14 Digit
Future<String> generateDesc4(RequestContext ctx, String group_code) async {
  DaerahTingkat3Repository dt3_repo = ctx.read<DaerahTingkat3Repository>();
  DaerahTingkat4Repository dt4_repo = ctx.read<DaerahTingkat4Repository>();
  DaerahTingkat5Repository dt5_repo = ctx.read<DaerahTingkat5Repository>();
  String cleanedString = group_code.trim();
  if(cleanedString.length != 14){
    throw Exception("Invalid Code Length");
  }
  
  DaerahTingkat3 dt3 = await dt3_repo.getById(cleanedString.substring(0,7));
  DaerahTingkat4 dt4 = await dt4_repo.getById(cleanedString.substring(0,10));
  DaerahTingkat5 daerah = await dt5_repo.getById("${cleanedString}");
  String desc = "[${daerah.id}] - Kec. ${dt3.name} - Desa/Kel ${dt4.name} - SLS ${daerah.name}";
  return desc;    
}