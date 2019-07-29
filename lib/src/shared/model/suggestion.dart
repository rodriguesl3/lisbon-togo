import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

import '../constant.dart';

class SuggestionModel {
  final String imageUrl, title, descriptionPlace;
  final double latitude, longitude;

  SuggestionModel(this.imageUrl, this.title, this.descriptionPlace, this.latitude, this.longitude);

  SuggestionModel.fromJson(Map json)
    :title = json['title'],
    imageUrl = json['imageUrl'],
    descriptionPlace = json['descriptionPlace'],
    latitude = json['latitude'],
    longitude = json['longitude'];
}
