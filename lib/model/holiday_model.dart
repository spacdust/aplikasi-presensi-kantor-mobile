class HolidayModel {
  HolidayModel({this.message, required this.holiday});

  String? message;
  List<Holiday> holiday;

  factory HolidayModel.fromJson(Map<String, dynamic> json) => HolidayModel(
        holiday: List<Holiday>.from(json["data"].map((x) => Holiday.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (holiday != null) {
      data['data'] = holiday?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Holiday {
  int? id;
  String? title;
  String? description;
  String? holidayDate;
  String? createdAt;
  String? updatedAt;

  Holiday({this.id, this.title, this.description, this.holidayDate, this.createdAt, this.updatedAt});

  Holiday.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    holidayDate = json['holiday_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['holiday_date'] = holidayDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
