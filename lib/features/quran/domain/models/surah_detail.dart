import '../../domain/models/surah.dart';

class Ayat {
  final int id;
  final int surah;
  final int nomor;
  final String ar;
  final String tr;
  final String idn;

  const Ayat({
    required this.id,
    required this.surah,
    required this.nomor,
    required this.ar,
    required this.tr,
    required this.idn,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) {
    return Ayat(
      id: json['id'] ?? 0,
      surah: json['surah'] ?? 0,
      nomor: json['nomor'] ?? 0,
      ar: json['ar'] ?? '',
      tr: json['tr'] ?? '',
      idn: json['idn'] ?? '',
    );
  }
}

class SurahDetail extends Surah {
  final List<Ayat> ayat;

  const SurahDetail({
    required super.nomor,
    required super.nama,
    required super.namaLatin,
    required super.jumlahAyat,
    required super.tempatTurun,
    required super.arti,
    required super.deskripsi,
    required super.audio,
    required this.ayat,
  });

  factory SurahDetail.fromJson(Map<String, dynamic> json) {
    List<Ayat> ayatList = [];
    if (json['ayat'] != null) {
      ayatList = (json['ayat'] as List).map((i) => Ayat.fromJson(i)).toList();
    }

    return SurahDetail(
      nomor: json['nomor'] ?? 0,
      nama: json['nama'] ?? '',
      namaLatin: json['nama_latin'] ?? '',
      jumlahAyat: json['jumlah_ayat'] ?? 0,
      tempatTurun: json['tempat_turun'] ?? '',
      arti: json['arti'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      audio: json['audio'] ?? '',
      ayat: ayatList,
    );
  }
}
