class LocationModel {
  LocationModel({this.message, required this.loc});

  String? message;
  List<Loc> loc;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        loc: List<Loc>.from(json["data"].map((x) => Loc.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (loc != null) {
      data['data'] = loc?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Loc {
  int? id;
  String? title;
  String? description;
  String? latitude;
  String? longitude;
  int? distance;
  String? createdAt;
  String? updatedAt;

  Loc(
      {this.id,
      this.title,
      this.description,
      this.latitude,
      this.longitude,
      this.distance,
      this.createdAt,
      this.updatedAt});

  Loc.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    distance = json['distance'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distance'] = distance;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
