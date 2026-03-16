import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

class WidgetService {
  static const String _groupId = 'group.muslim_time';
  static const String _androidWidgetName = 'PrayerTimeWidget';

  static Future<void> updateWidgetData({
    required String nextPrayerName,
    required String nextPrayerTime,
    required String location,
  }) async {
    await HomeWidget.setAppGroupId(_groupId);
    
    await HomeWidget.saveWidgetData('next_prayer_name', nextPrayerName);
    await HomeWidget.saveWidgetData('next_prayer_time', nextPrayerTime);
    await HomeWidget.saveWidgetData('location', location);
    await HomeWidget.saveWidgetData('last_update', DateFormat('HH:mm').format(DateTime.now()));

    await HomeWidget.updateWidget(
      name: _androidWidgetName,
      androidName: _androidWidgetName,
    );
  }
}
