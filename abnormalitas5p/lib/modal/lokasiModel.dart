class Lokasi {
  final String id;
  final String tempat;
 
  Lokasi({this.id, this.tempat});
 
  factory Lokasi.fromJson(Map<String, dynamic> parsedJson) {
    return Lokasi(
      id: parsedJson["id"],
      tempat: parsedJson["nama_wilayah"] as String,
    );
  }
}