import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/surah.dart';
import '../../domain/models/surah_detail.dart';

class QuranRepository {
  Future<List<Surah>> getSurahList() async {
    try {
      final String response =
          await rootBundle.loadString('assets/datas/listsurah.json');
      final data = json.decode(response);
      List<Surah> surahList =
          (data as List).map((i) => Surah.fromJson(i)).toList();
      return surahList;
    } catch (e) {
      throw Exception('Failed to load surah list: $e');
    }
  }

  Future<SurahDetail> getSurahDetail(int id) async {
    try {
      final String response =
          await rootBundle.loadString('assets/datas/surah/$id.json');
      final data = json.decode(response);
      return SurahDetail.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load surah detail: $e');
    }
  }
}
