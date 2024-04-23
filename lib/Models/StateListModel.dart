class StatesListModel {
  late int success;
  late bool message;
  List<StateListResult> result = [];

  StatesListModel({required this.success,required this.message,required this.result});

  StatesListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? '';
    message = json['message'] ?? false;
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result.add(new StateListResult.fromJson(v as Map<String, dynamic>));
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

class StateListResult {
  late String sId;
  late int id;
  late String name;

  StateListResult({required this.sId,required this.id,required this.name});

  StateListResult.fromJson(Map<String, dynamic> json) {
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
