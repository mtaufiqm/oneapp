import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/timezone.dart';
class DatetimeHelper {
  static bool isInitialized = false;
  static late Location makassarLocation;


  static Future<void> initInstance() async {
    if(isInitialized == false){
      //initialization process
      await tz.initializeTimeZone();
      makassarLocation = tz.getLocation("Asia/Makassar");

      //set initialized to true;
      isInitialized = true;
    }
  }

  static String getCurrentMakassarTime(){
    return tz.TZDateTime.now(makassarLocation).toIso8601String();
  }

  static DateTime parseMakassarTime(String makassarTime) {
    return tz.TZDateTime.parse(DatetimeHelper.makassarLocation,makassarTime);
  }

}