// import "package:flutter/material.dart";

String getWeek(weekDay) {
  String weekName = "";
  // var weekDay = 0;
  switch (weekDay) {
    //
    case 0:
      weekName = "Sun";
      break;
    case 1:
      weekName = "Mon";
      break;
    case 2:
      weekName = "Tue";
      break;
    case 3:
      weekName = "Wed";
      break;
    case 4:
      weekName = "Thu";
      break;
    case 5:
      weekName = "Fri";
      break;
    default:
      weekName = "Sat";
  }
  return weekName;
}
