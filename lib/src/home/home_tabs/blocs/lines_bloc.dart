import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:lisbon_togo/src/repositories/lines_repository.dart';
import 'package:lisbon_togo/src/shared/model/carrier_line.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class LinesBloc extends BlocBase {
  final LinesRepository linesRepo;
  LinesBloc(this.linesRepo);

  final BehaviorSubject<CarrierLineModel> _carrierController =
      BehaviorSubject.seeded(CarrierLineModel());
  final BehaviorSubject<String> _searchQueryController =
      BehaviorSubject.seeded("");

  Sink<String> get sinkSearchQuery => _searchQueryController.sink;

  Sink<CarrierLineModel> get sinkLine => _carrierController.sink;
  Observable<CarrierLineModel> get listLine =>
      _carrierController.stream.map((elm) => _carrierController.stream.value);

  void setCarrierLines({dynamic lines}) {
    var result = CarrierLineModel.fromJson(lines);

    if (_searchQueryController.value != "") {
      print(_searchQueryController.value);
      print(_searchQueryController.stream.value);

      result.data = result.data
          .where((elm) => elm.lineName
              .toLowerCase()
              .contains(_searchQueryController.stream.value.toLowerCase()))
          .toList();
    }

    sinkLine.add(result);
  }

  @override
  void dispose() {
    _carrierController.close();
    _searchQueryController.close();
    super.dispose();
  }
}
