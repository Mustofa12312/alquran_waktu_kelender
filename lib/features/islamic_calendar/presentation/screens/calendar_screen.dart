import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../../core/theme/app_theme.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool _showHijri = true;
  DateTime _selectedDate = DateTime.now();
  DateTime _viewMonth = DateTime.now();
  late HijriCalendar _viewHijriMonth;

  @override
  void initState() {
    super.initState();
    HijriCalendar.setLocal('ar');
    _viewHijriMonth = HijriCalendar.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('Kalender Islam', style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ToggleButtons(
              constraints: const BoxConstraints(minWidth: 60, minHeight: 32),
              borderRadius: BorderRadius.circular(20),
              color: AppColors.textMuted,
              selectedColor: AppColors.darkBg,
              fillColor: AppColors.gold,
              borderColor: AppColors.darkBorder,
              selectedBorderColor: AppColors.gold,
              isSelected: [_showHijri, !_showHijri],
              onPressed: (idx) => setState(() => _showHijri = idx == 0),
              children: const [
                Text('Hijri', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                Text('Masehi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMonthHeader(),
          _buildDayLabels(),
          _buildCalendarGrid(),
          const Divider(height: 1, color: AppColors.darkBorder),
          Expanded(child: _buildEventsList()),
        ],
      ),
    );
  }

  void _prevMonth() {
    setState(() {
      if (_showHijri) {
        int y = _viewHijriMonth.hYear;
        int m = _viewHijriMonth.hMonth - 1;
        if (m < 1) {
          m = 12;
          y--;
        }
        final firstDay = HijriCalendar.now().hijriToGregorian(y, m, 1);
        _viewHijriMonth = HijriCalendar.fromDate(firstDay);
      } else {
        _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1, 1);
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_showHijri) {
        int y = _viewHijriMonth.hYear;
        int m = _viewHijriMonth.hMonth + 1;
        if (m > 12) {
          m = 1;
          y++;
        }
        final firstDay = HijriCalendar.now().hijriToGregorian(y, m, 1);
        _viewHijriMonth = HijriCalendar.fromDate(firstDay);
      } else {
        _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 1);
      }
    });
  }

  Widget _buildMonthHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _prevMonth,
            icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
          ),
          Column(
            children: [
              Text(
                _showHijri
                    ? '${_viewHijriMonth.longMonthName} ${_viewHijriMonth.hYear} H'
                    : _getGregorianMonth(),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_showHijri)
                Text(
                  _getGregorianMonthEquivalent(),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
            ],
          ),
          IconButton(
            onPressed: _nextMonth,
            icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  String _getGregorianMonthEquivalent() {
    final firstDay = HijriCalendar.now().hijriToGregorian(_viewHijriMonth.hYear, _viewHijriMonth.hMonth, 1);
    const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return '${months[firstDay.month - 1]} ${firstDay.year}';
  }

  String _getGregorianMonth() {
    const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return '${months[_viewMonth.month - 1]} ${_viewMonth.year}';
  }

  Widget _buildDayLabels() {
    final days = _showHijri 
        ? ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد']
        : ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Directionality(
        textDirection: _showHijri ? TextDirection.rtl : TextDirection.ltr,
        child: Row(
          children: days.map((d) => Expanded(
            child: Center(
              child: Text(
                d,
                style: TextStyle(
                  color: (d == 'Jum' || d == 'الجمعة') ? AppColors.gold : AppColors.textSecondary,
                  fontSize: _showHijri ? 14 : 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: _showHijri ? 'Amiri' : null,
                ),
              ),
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    late DateTime firstDay;
    late int daysInMonth;

    if (_showHijri) {
      firstDay = HijriCalendar.now().hijriToGregorian(_viewHijriMonth.hYear, _viewHijriMonth.hMonth, 1);
      daysInMonth = _viewHijriMonth.lengthOfMonth;
    } else {
      firstDay = DateTime(_viewMonth.year, _viewMonth.month, 1);
      daysInMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 0).day;
    }

    // Monday = 0
    final startOffset = (firstDay.weekday - 1) % 7;
    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Directionality(
        textDirection: _showHijri ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: List.generate(rows, (row) {
          return Row(
            children: List.generate(7, (col) {
              final dayIndex = row * 7 + col - startOffset + 1;
              if (dayIndex < 1 || dayIndex > daysInMonth) {
                return const Expanded(child: SizedBox(height: 44));
              }

              late DateTime cellGregorianDate;
              late bool isToday;
              late bool isSelected;
              late bool isFriday;

              if (_showHijri) {
                cellGregorianDate = HijriCalendar.now().hijriToGregorian(_viewHijriMonth.hYear, _viewHijriMonth.hMonth, dayIndex);
                final today = HijriCalendar.now();
                isToday = _viewHijriMonth.hYear == today.hYear && _viewHijriMonth.hMonth == today.hMonth && dayIndex == today.hDay;
                
                final selectedHijri = HijriCalendar.fromDate(_selectedDate);
                isSelected = _viewHijriMonth.hYear == selectedHijri.hYear && _viewHijriMonth.hMonth == selectedHijri.hMonth && dayIndex == selectedHijri.hDay;
                isFriday = cellGregorianDate.weekday == 5;
              } else {
                cellGregorianDate = DateTime(_viewMonth.year, _viewMonth.month, dayIndex);
                final today = DateTime.now();
                isToday = cellGregorianDate.day == today.day && cellGregorianDate.month == today.month && cellGregorianDate.year == today.year;
                isSelected = cellGregorianDate.day == _selectedDate.day && cellGregorianDate.month == _selectedDate.month && cellGregorianDate.year == _selectedDate.year;
                isFriday = cellGregorianDate.weekday == 5;
              }

              String arabicNumber(int n) {
                const numbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
                return n.toString().split('').map((e) => numbers[int.parse(e)]).join();
              }
              
              final displayDay = _showHijri ? arabicNumber(dayIndex) : dayIndex.toString();

              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDate = cellGregorianDate),
                  child: Container(
                    height: 44,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : isToday
                              ? AppColors.gold.withOpacity(0.15)
                              : null,
                      borderRadius: BorderRadius.circular(10),
                      border: isToday
                          ? Border.all(color: AppColors.gold, width: 1.5)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      displayDay,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : isFriday
                                ? AppColors.gold
                                : AppColors.textPrimary,
                        fontSize: _showHijri ? 18 : 14,
                        fontFamily: _showHijri ? 'Amiri' : null,
                        fontWeight: isToday || isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    const events = [
      _EventData('Awal Ramadhan 1447 H', '1 Maret 2025', AppColors.gold),
      _EventData('Nuzulul Qur\'an', '17 Ramadhan', AppColors.primaryLight),
      _EventData('Malam Lailatul Qadr', '21-29 Ramadhan', AppColors.fajr),
      _EventData('Idul Fitri 1447 H', '31 Maret 2025', AppColors.success),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Agenda Islamiyah',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...events.map((e) => _buildEventItem(e)),
      ],
    );
  }

  Widget _buildEventItem(_EventData event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: event.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                event.date,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EventData {
  const _EventData(this.title, this.date, this.color);
  final String title;
  final String date;
  final Color color;
}
