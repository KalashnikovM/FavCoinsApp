import 'dart:convert';
import 'package:appwrite/models.dart';
import 'package:crypto_tracker/services/parse_data_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:watch_it/watch_it.dart';
import '../constants.dart';
import '../models/main_coin_model.dart';
import 'appwrite_service.dart';

class CloudFunctionsService extends ChangeNotifier {

  final db = di<ApiClient>().database;
  final functions = di<ApiClient>().functions;
  List<MainCoinModel> foundElementsList = [];
  Map<String, String> cloudFunctionsServiceError = {};

  Future<bool> getFunc(String symbol) async{
  bool res = false;

  debugPrint('result functions.createExecution();');
  Execution result = await functions.createExecution(
    functionId: '65f96862ad619d34eadf',
      body: symbol,
  );

  if(result.responseStatusCode == 200)
       {
    Map<String, dynamic> body = jsonDecode(result.responseBody);
    final Map<String, dynamic> bodyBata = body['data'];
    var data = bodyBata[symbol.toUpperCase()];
           debugPrint('${data.runtimeType}\data: $data');
        for(var item in data) {
          debugPrint('quote: ${item["quote"]}');

          try {

            final response = await db.getDocument(
              databaseId: databaseId,
              collectionId: coinDataCollection,
              documentId: item["id"].toString(),
            );
            final Document doc = response;
            MainCoinModel mainModel = await ParsingService().parseData(doc.data);


            foundElementsList.add(mainModel);
            debugPrint(mainModel.id);
            res = true;
          } catch (e) {
            res = false;
            cloudFunctionsServiceError[DateTime.now().toLocal().toString()] = "getTestList Error: $e";
            debugPrint('Error fetching last currency rate list: $e');
          }}}
        else {
    debugPrint('result responseStatusCode() ${result.responseStatusCode}');
    res = false;

  }

  debugPrint('result status() ${result.status}');
        return res;

}






}