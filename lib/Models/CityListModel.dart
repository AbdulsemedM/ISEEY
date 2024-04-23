class CityListModel {
  late int success;
  late bool message;
  List<CityListResult> result = [];

  CityListModel(
      {required this.success, required this.message, required this.result});

  CityListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    message = json['message'] ?? false;
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result.add(new CityListResult.fromJson(v as Map<String, dynamic>));
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

class CityListResult {
  late String sId;
  late int id;
  late String name;

  CityListResult({required this.sId, required this.id, required this.name});

  CityListResult.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
