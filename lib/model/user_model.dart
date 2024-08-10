class UserModel {
  String? message;
  Data? data;

  UserModel({this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;
  String? token;
  String? rolename;
  String? jabname;
  String? partname;

  Data({this.user, this.token, this.rolename, this.jabname, this.partname});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
    rolename = json['rolename'];
    jabname = json['jabatan'];
    partname = json['partof'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    data['rolename'] = rolename;
    data['jabatan'] = jabname;
    data['partof'] = partname;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? phone;
  String? positionId;
  // String? partofId;
  String? roleId;
  String? createdAt;
  String? updatedAt;
  String? facedata;

  User(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.phone,
      this.positionId,
      // this.partofId,
      this.roleId,
      this.createdAt,
      this.updatedAt,
      this.facedata});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    positionId = json['position_id'].toString();
    // partofId = json['partof_id'].toString();
    roleId = json['role_id'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    facedata = json['facedata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['phone'] = phone;
    data['position_id'] = positionId;
    // data['partof_id'] = partofId;
    data['role_id'] = roleId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['facedata'] = facedata;
    return data;
  }
}
