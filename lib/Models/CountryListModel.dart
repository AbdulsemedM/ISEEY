class CountryListModel {
  late int success;
  late bool message;
  List<CountryListResult> result = [];

  CountryListModel(
      {required this.success, required this.message, required this.result});

  CountryListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    message = json['message'] ?? false;
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result.add(new CountryListResult.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['result'] = this.result.map((v) => v.toJson()).toList();
    return data;
  }
}

class CountryListResult {
  late String sId;
  late String iso2;
  late int id;
  late String name;

  CountryListResult(
      {required this.sId,
      required this.iso2,
      required this.id,
      required this.name});

  CountryListResult.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    iso2 = json['iso2'] ?? '';
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['iso2'] = this.iso2;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
