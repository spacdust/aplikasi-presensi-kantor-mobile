class PermissionModel {
  PermissionModel({this.message, required this.perm});

  String? message;
  List<Perm> perm;

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      PermissionModel(
        perm: List<Perm>.from(json["data"].map((x) => Perm.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (perm != null) {
      data['data'] = perm?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Perm {
  String? id;
  String? userId;
  String? attendanceId;
  String? title;
  String? description;
  String? permissionDate;
  String? isAccepted;
  String? createdAt;
  String? updatedAt;

  Perm(
      {this.id,
      this.userId,
      this.attendanceId,
      this.title,
      this.description,
      this.permissionDate,
      this.isAccepted,
      this.createdAt,
      this.updatedAt});

  Perm.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    attendanceId = json['attendance_id'].toString();
    title = json['title'];
    description = json['description'];
    permissionDate = json['permission_date'];
    isAccepted = json['is_accepted'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['attendance_id'] = attendanceId;
    data['title'] = title;
    data['description'] = description;
    data['permission_date'] = permissionDate;
    data['is_accepted'] = isAccepted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
