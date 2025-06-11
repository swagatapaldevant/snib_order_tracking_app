class GetOrderList {
  String? sId;
  Requisition? requisition;
  String? deliveryPartner;
  PickupFrom? pickupFrom;
  String? pickupDate;
  PickupFrom? dropOutAt;
  String? dropOutDate;
  String? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GetOrderList(
      {this.sId,
        this.requisition,
        this.deliveryPartner,
        this.pickupFrom,
        this.pickupDate,
        this.dropOutAt,
        this.dropOutDate,
        this.status,
        this.deleted,
        this.createdAt,
        this.updatedAt,
        this.iV});

  GetOrderList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    requisition = json['requisition'] != null
        ? new Requisition.fromJson(json['requisition'])
        : null;
    deliveryPartner = json['deliveryPartner'];
    pickupFrom = json['pickupFrom'] != null
        ? new PickupFrom.fromJson(json['pickupFrom'])
        : null;
    pickupDate = json['pickupDate'];
    dropOutAt = json['dropOutAt'] != null
        ? new PickupFrom.fromJson(json['dropOutAt'])
        : null;
    dropOutDate = json['dropOutDate'];
    status = json['status'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.requisition != null) {
      data['requisition'] = this.requisition!.toJson();
    }
    data['deliveryPartner'] = this.deliveryPartner;
    if (this.pickupFrom != null) {
      data['pickupFrom'] = this.pickupFrom!.toJson();
    }
    data['pickupDate'] = this.pickupDate;
    if (this.dropOutAt != null) {
      data['dropOutAt'] = this.dropOutAt!.toJson();
    }
    data['dropOutDate'] = this.dropOutDate;
    data['status'] = this.status;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Requisition {
  String? sId;
  String? billNo;
  String? uniqueNo;
  String? status;

  Requisition({this.sId, this.billNo, this.uniqueNo, this.status});

  Requisition.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    billNo = json['billNo'];
    uniqueNo = json['uniqueNo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['billNo'] = this.billNo;
    data['uniqueNo'] = this.uniqueNo;
    data['status'] = this.status;
    return data;
  }
}

class PickupFrom {
  String? sId;
  String? name;
  String? city;
  String? pincode;
  String? address;
  String? ap1Name;
  String? ap1Phone;
  String? ap2Name;
  String? ap2Phone;
  double? lat;
  double? long;
  int? iV;

  PickupFrom(
      {this.sId,
        this.name,
        this.city,
        this.pincode,
        this.address,
        this.ap1Name,
        this.ap1Phone,
        this.ap2Name,
        this.ap2Phone,
        this.lat,
        this.long,
        this.iV});

  PickupFrom.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    city = json['city'];
    pincode = json['pincode'];
    address = json['address'];
    ap1Name = json['ap1Name'];
    ap1Phone = json['ap1Phone'];
    ap2Name = json['ap2Name'];
    ap2Phone = json['ap2Phone'];
    lat = json['lat'];
    long = json['long'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['address'] = this.address;
    data['ap1Name'] = this.ap1Name;
    data['ap1Phone'] = this.ap1Phone;
    data['ap2Name'] = this.ap2Name;
    data['ap2Phone'] = this.ap2Phone;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['__v'] = this.iV;
    return data;
  }
}