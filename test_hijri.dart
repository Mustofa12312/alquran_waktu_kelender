import 'package:hijri/hijri_calendar.dart'; void main() { HijriCalendar.setLocal('ar'); final h = HijriCalendar.now(); print(h.toFormat('dd MMMM yyyy')); }
