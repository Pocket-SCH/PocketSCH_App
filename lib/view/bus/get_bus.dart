class Data {
  int id;
  int type;
  String busTime;
  int busWeekDay;

  Data(this.id, this.type, this.busTime, this.busWeekDay);

  factory Data.fromJson(dynamic json) {
    return Data(json['id'] as int, json['type'] as int,
        json['busTime'] as String, json['busWeekDay'] as int);
  }
  @override
  String toString() {
    return '{${this.id}, ${this.type}, ${this.busTime}, ${this.busWeekDay}}';
  }
}
