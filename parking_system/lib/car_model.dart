class CarModel {
  String? name;
  bool? isParked;
  bool? booked;
  String? parkedFrom;
  String? parkedTo;
  String? parkingHours;

  CarModel(
      {this.name,
      this.isParked,
      this.booked,
      this.parkingHours,
      this.parkedFrom,
      this.parkedTo});

  CarModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    isParked = json["isParked"];
    booked = json["booked"];
    parkedFrom = json["parkedFrom"];
    parkedTo = json["parkedTo"];
    parkingHours = json["parkingHours"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["isParked"] = isParked;
    _data["booked"] = booked;
    _data["parkedFrom"] = parkedFrom;
    _data["parkingHours"] = parkingHours;
    _data["parkedTo"] = parkedTo;
    return _data;
  }
}
