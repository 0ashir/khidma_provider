class SystemLanguage {
  int? id;
  String? name;
  String? locale;
  String? flag;
  String? appLocale;
  int? isRtl;
  int? status;
  int? systemReserve;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? flagPath;

  SystemLanguage(
      {this.id,
        this.name,
        this.locale,
        this.flag,
        this.appLocale,
        this.isRtl,
        this.status,
        this.systemReserve,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.flagPath});

  SystemLanguage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    locale = json['locale'];
    flag = json['flag'];
    appLocale = json['app_locale'];
    isRtl = json['is_rtl'];
    status = json['status'];
    systemReserve = json['system_reserve'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    flagPath = json['flag_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['locale'] = locale;
    data['flag'] = flag;
    data['app_locale'] = appLocale;
    data['is_rtl'] = isRtl;
    data['status'] = status;
    data['system_reserve'] = systemReserve;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['flag_path'] = flagPath;
    return data;
  }
}
