import 'package:lisbon_togo/src/shared/database/database_creator.dart';
import 'package:lisbon_togo/src/shared/model/prediction_model.dart';
import 'package:sqflite/sqflite.dart';

class PredictionRepository {
  static Future<List<PredictionModel>> getAllPredictions() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.predictionTable}''';
    final data = await db.rawQuery(sql);

    return (data as List)
        .map((prediction) => PredictionModel.fromJson(prediction))
        .toList();
  }

  static Future<PredictionModel> getPredictionById(int id) async {
    final sql =
        '''SELECT * FROM ${DatabaseCreator.predictionTable} WHERE ${DatabaseCreator.id} == $id''';
    final data = await db.rawQuery(sql);

    final prediction = PredictionModel.fromJson(data[0]);

    return prediction;
  }

  static Future<int> addPrediction(PredictionModel prediction) async {
    final sql = '''INSERT INTO ${DatabaseCreator.predictionTable}
    (${DatabaseCreator.id},
     ${DatabaseCreator.placeId},
     ${DatabaseCreator.reference},
     ${DatabaseCreator.description},
     ${DatabaseCreator.phoneNumber},
     ${DatabaseCreator.name},
     ${DatabaseCreator.latitude},
     ${DatabaseCreator.longitude}
     )
     VALUES
     (
       '${prediction.id}',
       '${prediction.placeId}',
       '${prediction.reference}',
       '${prediction.description}',
       '${prediction.phoneNumber}',
       '${prediction.name}',
       '${prediction.latitude}',
       '${prediction.longitude}'
     )''';

    final result = await db.rawInsert(sql);
    DatabaseCreator.databaseLog('Add prediction', sql, null, result);

    return result;
  }

  static Future<int> removePrediction(PredictionModel prediction) async {
    final sql = '''DELETE FROM ${DatabaseCreator.predictionTable} WHERE ${DatabaseCreator.id} = ${prediction.id}''';

    var result = await db.rawDelete(sql);
    return result;
  }

}
