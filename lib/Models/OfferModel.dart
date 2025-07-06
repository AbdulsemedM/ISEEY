class OfferModel {
  late bool success; 
  late String message;
  List<OfferListResult> result = [];

  OfferModel({required this.success, required this.message, required this.result});

  OfferModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] as bool;
    message = json['message'] ?? '';
    if (json['data'] != null) { 
      result = [];
      json['data'].forEach((v) {
        result.add(new OfferListResult.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.result.map((v) => v.toJson()).toList(); // Changed from 'result' to 'data'
    return data;
  }
}

class OfferListResult {
  late String sId;
  late String image;
  late String deleted;
  late String name;
  late int discount;
  late String code;
  late int startDate;
  late int endDate;
  late String restaurantId;
  late String description;
  late String offerType;
  late int created;
  late int updated;
  late int iV;
  CurrencyDetails? currencyDetails;

  OfferListResult(
      {required this.sId,
        required this.image,
        required this.deleted,
        required this.name,
        required this.discount,
        required this.code,
        required this.startDate,
        required this.endDate,
      required this.restaurantId,
        required this.description,
        required this.offerType,
        required this.created,
        required this.updated,
        required this.iV,
      this.currencyDetails});

  OfferListResult.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    image = json['image'] ?? '';
    deleted = json['deleted'] ?? '';
    name = json['name'] ?? '';
    discount = json['discount'] ?? 0;
    code = json['code'] ?? '';
    startDate = json['start_date'] ?? 0;
    endDate = json['end_date'] ?? 0;
    restaurantId = json['restaurant_id'] ?? '';
    description = json['description'] ?? '';
    offerType = json['offer_type'] ?? '';
    created = json['created'] ?? 0;
    updated = json['updated'] ?? 0;
    iV = json['__v'] ?? 0;
    currencyDetails = json['currency'] != null
        ? new CurrencyDetails.fromJson(json['currency'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['image'] = this.image;
    data['deleted'] = this.deleted;
    data['name'] = this.name;
    data['discount'] = this.discount;
    data['code'] = this.code;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['restaurant_id'] = this.restaurantId;
    data['description'] = this.description;
    data['offer_type'] = this.offerType;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['__v'] = this.iV;
    if (this.currencyDetails != null) {
      data['currency'] = this.currencyDetails?.toJson();
    }
    return data;
  }
}

class CurrencyDetails {
  late String symbol;
  late String name;

  CurrencyDetails({required this.symbol,required this.name});

  CurrencyDetails.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'] ?? '';
    name = json['name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symbol'] = this.symbol;
    data['name'] = this.name;
    return data;
  }
}
