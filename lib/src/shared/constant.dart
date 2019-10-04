//const String URL_API = "http://10.0.2.2:5000/api/";

class ConstantsValues {
  static const String URL_API = "http://35.246.82.95/api/";
  //static const String URL_API = "http://192.168.1.67:5000/api/";
  static const String DIRECTION_KEY = "AIzaSyC7Exvy4fyWdWyONtpptneRWU4J54wHoF0";

  static String getDirection(String fromLatitude, String fromLongitude,
          String toLatitude, String toLongitude) =>
      "https://maps.googleapis.com/maps/api/directions/json?mode=walking&origin=$fromLatitude,$fromLongitude&destination=$toLatitude,$toLongitude&key=$DIRECTION_KEY";
}