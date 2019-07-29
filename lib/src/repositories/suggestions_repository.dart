import 'package:dio/dio.dart';
import 'package:lisbon_togo/src/shared/model/suggestion.dart';

class SuggestionsRepository {
  final Dio requestClient;

  SuggestionsRepository(this.requestClient);

  Future<List<SuggestionModel>> getSuggestions() async {
    Response response = await requestClient.get("/suggestions");
    return (response.data as List)
        .map((suggestion) => SuggestionModel.fromJson(suggestion))
        .toList();
  }
}
