import 'package:hijri/hijri_calendar.dart'; void main() { final h = HijriCalendar.now(); h.hDay=1; print(h.lengthOfMonth); print(h.hijriToGregorian(h.hYear, h.hMonth, 1)); print(h.longMonthName); }
