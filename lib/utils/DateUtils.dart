import 'package:intl/intl.dart';
class DateUtils{
static  String DateFormate(int time){
    /*
    * This function converts milliseconds to formatted string..
    * @param time: time in milliseconds
    * @return String: Formatted date (ex:jan 20,2020)
    * */
    var date = DateTime.fromMillisecondsSinceEpoch(time);
    var formattedDate = DateFormat.yMMMd().format(date);
    return formattedDate.toString();
}



}