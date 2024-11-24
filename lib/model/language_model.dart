class LanguageModel {
  int? id;
  String? locale;
  String? name;
  String? fbName;
  String? createdAt;
  String? updatedAt;
  String? animLiveName;

  LanguageModel(
      {this.id, this.locale, this.name, this.fbName, this.createdAt, this.updatedAt, this.animLiveName});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locale = json['locale'];
    name = json['name'];
    fbName = json['fbName'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    animLiveName = json['animLiveName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['locale'] = locale;
    data['name'] = name;
    data['fbName'] = fbName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['animLiveName'] = animLiveName;
    return data;
  }
}
