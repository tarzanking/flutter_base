class UserModel {
  Profile? profile;

  UserModel({
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
  );

  Map<String, dynamic> toJson() => {
    "profile": profile == null ? null : profile!.toJson(),
  };
}

class Profile {
  String? memberCode;
  String? token;

  Profile({
    this.memberCode,
    this.token,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    memberCode: json["memberCode"] == null ? null : json["memberCode"],
    token: json["token"] == null ? null : json["token"],
  );

  Map<String, dynamic> toJson() => {
    "memberCode": memberCode == null ? null : memberCode,
    "token": token == null ? null : token,
  };
}