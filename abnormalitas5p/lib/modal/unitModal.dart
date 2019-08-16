class Unit {
  final String id;
  final String unit;
 
  Unit({this.id, this.unit});
 
  factory Unit.fromJson(Map<String, dynamic> parsedJson) {
    return Unit(
      id: parsedJson["id"],
      unit: parsedJson["unit"] as String,
    );
  }
}