class CarrierLineModel {
  List<Data> data;

  CarrierLineModel({this.data});

  CarrierLineModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String carrierUrl;
  String carrierImage;
  String detailLineUrl;
  String lineName;

  Data({this.carrierUrl, this.carrierImage, this.detailLineUrl, this.lineName});

  Data.fromJson(Map<String, dynamic> json) {
    carrierUrl = json['carrierUrl'];
    carrierImage = json['carrierImage'];
    detailLineUrl = json['detailLineUrl'];
    lineName = json['lineName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['carrierUrl'] = this.carrierUrl;
    data['carrierImage'] = this.carrierImage;
    data['detailLineUrl'] = this.detailLineUrl;
    data['lineName'] = this.lineName;
    return data;
  }
}
