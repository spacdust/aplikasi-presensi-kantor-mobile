class AttendanceModel {
  AttendanceModel({this.message, required this.att});

  String? message;
  List<Att> att;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
        att: List<Att>.from(json["data"].map((x) => Att.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (att != null) {
      data['data'] = att?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Att {
  int? id;
  String? title;
  String? description;
  String? startTime;
  String? batasStartTime;
  String? endTime;
  String? batasEndTime;

  Att(
      {this.id,
      this.title,
      this.description,
      this.startTime,
      this.batasStartTime,
      this.endTime,
      this.batasEndTime});

  Att.fromJson(Map<String, dynamic> json) {
    id = json['attendance_id'];
    title = json['title'];
    description = json['description'];
    startTime = json['start_time'];
    batasStartTime = json['batas_start_time'];
    endTime = json['end_time'];
    batasEndTime = json['batas_end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['start_time'] = startTime;
    data['batas_start_time'] = batasStartTime;
    data['end_time'] = endTime;
    data['batas_end_time'] = batasEndTime;
    return data;
  }
}
