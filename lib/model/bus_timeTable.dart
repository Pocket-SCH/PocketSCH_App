class BusTimeTable {
  // 필드명
  final int? id;
  final int? type;
  final String? busTime;
  final int? busWeekDay;

  // 생성자
  BusTimeTable({
    this.id,
    this.type,
    this.busTime,
    this.busWeekDay,
  });

  factory BusTimeTable.fromJson(Map<String, dynamic> json) {
    return BusTimeTable(
      id: json["id"] as int,
      type: json["type"] as int,
      busTime: json["busTime"] as String,
      busWeekDay: json["busWeekDay"] as int,
    );
  }
}
