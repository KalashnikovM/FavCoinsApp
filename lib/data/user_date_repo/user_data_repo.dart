import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:appwrite/models.dart';

import '../../constants.dart';
import '../../services/appwrite_service.dart';




class UserDataRepo extends ChangeNotifier{
  var _database = di<ApiClient>().database;



  Future<String> _getDeviceIdentifier() async {
    String userId = '';

    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      userId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      userId = iosInfo.identifierForVendor.toString();
    }
      return userId;
  }




  _createUser(documentId) async {
    debugPrint('createUser()');


    try {

      Future result =
      _database.createDocument(
          databaseId: databaseId,
          collectionId: usersCollection,
          documentId: documentId,
          data: { 'device': 'Iphone'},
      );




      await result.then((response) {
        debugPrint('response');
        debugPrint(response.toString());

      }).catchError((error) {

        debugPrint(error.toString());
        }
      );


    } catch (e) {
      debugPrint('!!!!!!!');

      debugPrint(e.runtimeType.toString());
      debugPrint(e.toString());

    }


  }




  checkUserId() async {
    debugPrint('checkUserId()');

    var documentId = await _getDeviceIdentifier();




    try {

      Future result = _database.getDocument(
          databaseId: databaseId,
          collectionId: usersCollection,
          documentId: documentId);




      await result.then((response) {
        Document doc = response;
        if (doc.$id == documentId) {

          debugPrint('user found \n doc.id ${doc.$id} \n documentId $documentId');


        }
        debugPrint(doc.runtimeType.toString());
        debugPrint(doc.toString());

      }).catchError((error) {
        if (error.type == 'document_not_found') {
          _createUser(documentId);
        }
        debugPrint('error');
        debugPrint(error.toString());


      });


    } on AppwriteException catch (e) {

      debugPrint('@@@@@@@');

      debugPrint(e.message);
         debugPrint(e.code.toString());

         debugPrint('@@@@@@@');
    }



  }











}
