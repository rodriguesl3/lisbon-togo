import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:lisbon_togo/src/repositories/suggestions_repository.dart';
import 'package:lisbon_togo/src/shared/model/suggestion.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class SuggestionBLoc extends BlocBase {
  BuildContext context;
  SuggestionsRepository suggestionsRepository;
  final BehaviorSubject _listController = BehaviorSubject.seeded(true);

  SuggestionBLoc(this.suggestionsRepository);

  Observable<List<SuggestionModel>> get listOut => _listController.stream
      .asyncMap((v) => suggestionsRepository.getSuggestions());

  Sink get listIn => _listController.sink;


  @override
  void dispose() {
    _listController.close();
    super.dispose();
  }

}
