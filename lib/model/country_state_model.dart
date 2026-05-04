class CountryStateModel {
  int? id;
  String? name;
  List<StateModel>? state;
  String? currency;
  String? currencySymbol;
  String? iso31662;
  String? iso31663;
  String? phoneCode;
  String? flag;
  String? currencyCode;

  CountryStateModel(
      {this.id,
      this.name,
      this.currency,
      this.currencySymbol,
      this.iso31662,
      this.iso31663,
      this.phoneCode,
      this.flag,
      this.currencyCode,
      this.state});

  CountryStateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    currency = json['currency'];
    currencySymbol = json['currency_symbol'];
    iso31662 = json['iso_3166_2'];
    iso31663 = json['iso_3166_3'];
    phoneCode = json['phone_code'];
    flag = json['flag'];
    currencyCode = json['currency_code'];
    if (json['state'] != null) {
      state = <StateModel>[];
      json['state'].forEach((v) {
        state!.add(StateModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['currency'] = currency;
    data['currency_symbol'] = currencySymbol;
    data['iso_3166_2'] = iso31662;
    data['iso_3166_3'] = iso31663;
    data['phone_code'] = phoneCode;
    data['flag'] = flag;
    data['currency_code'] = currencyCode;
    if (state != null) {
      data['state'] = state!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static List<CountryStateModel>? fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => CountryStateModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${id} ${name}';
  }

  ///this method will prevent the override of toString
  userAsStringById() {
    return id.toString();
  }

  ///this method will prevent the override of toString
  bool userFilterByCreationDate(String filter) {
    return name.toString().contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(CountryStateModel model) {
    return id == model.id;
  }
}

class StateModel {
  int? id;
  String? name;
  int? countryId;
  String? createdAt;
  String? updatedAt;

  StateModel(
      {this.id, this.name, this.countryId, this.createdAt, this.updatedAt});

  StateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['country_id'] = countryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
