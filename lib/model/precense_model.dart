class PrecenseModel {
  PrecenseModel({this.message, required this.pre});

  String? message;
  List<Pre> pre;

  factory PrecenseModel.fromJson(Map<String, dynamic> json) => PrecenseModel(
        pre: List<Pre>.from(json["data"].map((x) => Pre.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (pre != null) {
      data['data'] = pre?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pre {
  String? id;
  String? userId;
  String? attendanceId;
  String? presenceDate;
  String? presenceEnterTime;
  String? presenceOutTime;
  String? isPermission;
  String? status;
  String? workingHours;
  String? createdAt;
  String? updatedAt;
  String? title;
  String? batasStartTime;

  Pre({
    this.id,
    this.userId,
    this.attendanceId,
    this.presenceDate,
    this.presenceEnterTime,
    this.presenceOutTime,
    this.isPermission,
    this.status,
    this.workingHours,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.batasStartTime,
  });

  Pre.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    attendanceId = json['attendance_id'].toString();
    presenceDate = json['presence_date'];
    presenceEnterTime = json['presence_enter_time'];
    presenceOutTime = json['presence_out_time'];
    isPermission = json['is_permission'].toString();
    status = json['status'];
    workingHours = json['working_hours'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
    batasStartTime = json['batas_start_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['attendance_id'] = attendanceId;
    data['presence_date'] = presenceDate;
    data['presence_enter_time'] = presenceEnterTime;
    data['presence_out_time'] = presenceOutTime;
    data['is_permission'] = isPermission;
    data['status'] = status;
    data['working_hours'] = workingHours;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['title'] = title;
    data['batas_start_time'] = batasStartTime;
    return data;
  }
}
