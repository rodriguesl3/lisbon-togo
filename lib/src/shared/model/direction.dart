import 'dart:convert';

Directions directionsFromJson(String str) => Directions.fromJson(json.decode(str));

String directionsToJson(Directions data) => json.encode(data.toJson());

class Directions {
    List<GeocodedWaypoint> geocodedWaypoints;
    List<Route> routes;
    String status;

    Directions({
        this.geocodedWaypoints,
        this.routes,
        this.status,
    });

    factory Directions.fromJson(Map<String, dynamic> json) => new Directions(
        geocodedWaypoints: new List<GeocodedWaypoint>.from(json["geocoded_waypoints"].map((x) => GeocodedWaypoint.fromJson(x))),
        routes: new List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "geocoded_waypoints": new List<dynamic>.from(geocodedWaypoints.map((x) => x.toJson())),
        "routes": new List<dynamic>.from(routes.map((x) => x.toJson())),
        "status": status,
    };
}

class GeocodedWaypoint {
    String geocoderStatus;
    String placeId;
    List<String> types;

    GeocodedWaypoint({
        this.geocoderStatus,
        this.placeId,
        this.types,
    });

    factory GeocodedWaypoint.fromJson(Map<String, dynamic> json) => new GeocodedWaypoint(
        geocoderStatus: json["geocoder_status"],
        placeId: json["place_id"],
        types: new List<String>.from(json["types"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "geocoder_status": geocoderStatus,
        "place_id": placeId,
        "types": new List<dynamic>.from(types.map((x) => x)),
    };
}

class Route {
    Bounds bounds;
    String copyrights;
    List<Leg> legs;
    Polyline overviewPolyline;
    String summary;
    List<String> warnings;
    List<dynamic> waypointOrder;

    Route({
        this.bounds,
        this.copyrights,
        this.legs,
        this.overviewPolyline,
        this.summary,
        this.warnings,
        this.waypointOrder,
    });

    factory Route.fromJson(Map<String, dynamic> json) => new Route(
        bounds: Bounds.fromJson(json["bounds"]),
        copyrights: json["copyrights"],
        legs: new List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x))),
        overviewPolyline: Polyline.fromJson(json["overview_polyline"]),
        summary: json["summary"],
        warnings: new List<String>.from(json["warnings"].map((x) => x)),
        waypointOrder: new List<dynamic>.from(json["waypoint_order"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "bounds": bounds.toJson(),
        "copyrights": copyrights,
        "legs": new List<dynamic>.from(legs.map((x) => x.toJson())),
        "overview_polyline": overviewPolyline.toJson(),
        "summary": summary,
        "warnings": new List<dynamic>.from(warnings.map((x) => x)),
        "waypoint_order": new List<dynamic>.from(waypointOrder.map((x) => x)),
    };
}

class Bounds {
    Northeast northeast;
    Northeast southwest;

    Bounds({
        this.northeast,
        this.southwest,
    });

    factory Bounds.fromJson(Map<String, dynamic> json) => new Bounds(
        northeast: Northeast.fromJson(json["northeast"]),
        southwest: Northeast.fromJson(json["southwest"]),
    );

    Map<String, dynamic> toJson() => {
        "northeast": northeast.toJson(),
        "southwest": southwest.toJson(),
    };
}

class Northeast {
    double lat;
    double lng;

    Northeast({
        this.lat,
        this.lng,
    });

    factory Northeast.fromJson(Map<String, dynamic> json) => new Northeast(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
    };
}

class Leg {
    Distance distance;
    Distance duration;
    String endAddress;
    Northeast endLocation;
    String startAddress;
    Northeast startLocation;
    List<Step> steps;
    List<dynamic> trafficSpeedEntry;
    List<dynamic> viaWaypoint;

    Leg({
        this.distance,
        this.duration,
        this.endAddress,
        this.endLocation,
        this.startAddress,
        this.startLocation,
        this.steps,
        this.trafficSpeedEntry,
        this.viaWaypoint,
    });

    factory Leg.fromJson(Map<String, dynamic> json) => new Leg(
        distance: Distance.fromJson(json["distance"]),
        duration: Distance.fromJson(json["duration"]),
        endAddress: json["end_address"],
        endLocation: Northeast.fromJson(json["end_location"]),
        startAddress: json["start_address"],
        startLocation: Northeast.fromJson(json["start_location"]),
        steps: new List<Step>.from(json["steps"].map((x) => Step.fromJson(x))),
        trafficSpeedEntry: new List<dynamic>.from(json["traffic_speed_entry"].map((x) => x)),
        viaWaypoint: new List<dynamic>.from(json["via_waypoint"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "distance": distance.toJson(),
        "duration": duration.toJson(),
        "end_address": endAddress,
        "end_location": endLocation.toJson(),
        "start_address": startAddress,
        "start_location": startLocation.toJson(),
        "steps": new List<dynamic>.from(steps.map((x) => x.toJson())),
        "traffic_speed_entry": new List<dynamic>.from(trafficSpeedEntry.map((x) => x)),
        "via_waypoint": new List<dynamic>.from(viaWaypoint.map((x) => x)),
    };
}

class Distance {
    String text;
    int value;

    Distance({
        this.text,
        this.value,
    });

    factory Distance.fromJson(Map<String, dynamic> json) => new Distance(
        text: json["text"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "value": value,
    };
}

class Step {
    Distance distance;
    Distance duration;
    Northeast endLocation;
    String htmlInstructions;
    Polyline polyline;
    Northeast startLocation;
    String travelMode;
    String maneuver;

    Step({
        this.distance,
        this.duration,
        this.endLocation,
        this.htmlInstructions,
        this.polyline,
        this.startLocation,
        this.travelMode,
        this.maneuver,
    });

    factory Step.fromJson(Map<String, dynamic> json) => new Step(
        distance: Distance.fromJson(json["distance"]),
        duration: Distance.fromJson(json["duration"]),
        endLocation: Northeast.fromJson(json["end_location"]),
        htmlInstructions: json["html_instructions"],
        polyline: Polyline.fromJson(json["polyline"]),
        startLocation: Northeast.fromJson(json["start_location"]),
        travelMode: json["travel_mode"],
        maneuver: json["maneuver"] == null ? null : json["maneuver"],
    );

    Map<String, dynamic> toJson() => {
        "distance": distance.toJson(),
        "duration": duration.toJson(),
        "end_location": endLocation.toJson(),
        "html_instructions": htmlInstructions,
        "polyline": polyline.toJson(),
        "start_location": startLocation.toJson(),
        "travel_mode": travelMode,
        "maneuver": maneuver == null ? null : maneuver,
    };
}

class Polyline {
    String points;

    Polyline({
        this.points,
    });

    factory Polyline.fromJson(Map<String, dynamic> json) => new Polyline(
        points: json["points"],
    );

    Map<String, dynamic> toJson() => {
        "points": points,
    };
}
