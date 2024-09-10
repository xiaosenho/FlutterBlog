import 'package:flutter/material.dart';

class TimeAgoText extends StatelessWidget {
  final String dateTime;

  const TimeAgoText({Key? key, required this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    DateTime dateTime = _parseDateString(this.dateTime);

    // 计算时间差
    final difference = now.difference(dateTime);
    if(difference.inMinutes<60){
      return Text('${difference.inMinutes}分钟前',style: Theme.of(context).textTheme.bodyMedium,);
    } else if (difference.inHours < 24) {
      return Text('${difference.inHours}小时前',style: Theme.of(context).textTheme.bodyMedium,);
    } else if (difference.inDays >= 1 && difference.inDays <= 7) {
      return Text('${difference.inDays}天前',style: Theme.of(context).textTheme.bodyMedium,);
    } else if(difference.inDays >= 8 && difference.inDays <= 365){
      return Text('${dateTime.month}-${dateTime.day}',style: Theme.of(context).textTheme.bodyMedium,);
    }else {
      return Text('${dateTime.year}-${dateTime.month}-${dateTime.day}',style: Theme.of(context).textTheme.bodyMedium,);
    }
  }

  DateTime _parseDateString(String dateString) {
    Map<String, int> monthMap = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4,
      'May': 5, 'Jun': 6, 'Jul': 7, 'Aug': 8,
      'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
    };
    List<String> parts = dateString.split(', ');

    String monthAbbreviation = parts[0].split(' ')[0];
    int month = monthMap[monthAbbreviation]!;
    int day = int.parse(parts[0].split(' ')[1]);
    int year = int.parse(parts[1]);
    List<String> timeList = _splitTimeString(parts[2]);
    String meridiem = timeList[1];
    String time =  timeList[0];
    List<String> timeParts = time.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = int.parse(timeParts[2]);

    if (meridiem == 'PM' && hour != 12) {
      hour += 12;
    } else if (meridiem == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(year, month, day, hour, minute, second);
  }
  List<String> _splitTimeString(String timeString) {
    RegExp regExp = RegExp(r'\s+');
    return timeString.split(regExp);
  }
}