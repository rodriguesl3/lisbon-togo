import 'dart:convert';

NextBusModel nextBusModelFromJson(String str) => NextBusModel.fromJson(json.decode(str));

String nextBusModelToJson(NextBusModel data) => json.encode(data.toJson());

class NextBusModel {
    String fromLocation;
    String toLocation;
    String leaveAt;
    String arriveAt;
    String transportTransfer;
    String footPrintCarbon;
    String timeDuration;
    String price;
    String distanceInMeters;
    List<dynamic> routeSteps;

    NextBusModel({
        this.fromLocation,
        this.toLocation,
        this.leaveAt,
        this.arriveAt,
        this.transportTransfer,
        this.footPrintCarbon,
        this.timeDuration,
        this.price,
        this.distanceInMeters,
        this.routeSteps,
    });

    factory NextBusModel.fromJson(Map<String, dynamic> json) => NextBusModel(
        fromLocation: json["fromLocation"],
        toLocation: json["toLocation"],
        leaveAt: json["leaveAt"],
        arriveAt: json["arriveAt"],
        transportTransfer: json["transportTransfer"],
        footPrintCarbon: json["footPrintCarbon"],
        timeDuration: json["timeDuration"],
        price: json["price"],
        distanceInMeters: json["distanceInMeters"],
        routeSteps: List<dynamic>.from(json["routeSteps"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "fromLocation": fromLocation,
        "toLocation": toLocation,
        "leaveAt": leaveAt,
        "arriveAt": arriveAt,
        "transportTransfer": transportTransfer,
        "footPrintCarbon": footPrintCarbon,
        "timeDuration": timeDuration,
        "price": price,
        "distanceInMeters": distanceInMeters,
        "routeSteps": List<dynamic>.from(routeSteps.map((x) => x)),
    };
}