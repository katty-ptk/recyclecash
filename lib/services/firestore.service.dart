import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;

  Future<String> getUserName() async {
    DocumentReference<Map<String, dynamic>> userDoc =
    db.collection('users').doc('Osbm2OzwhYVd5fPFsWnHudTPezX2');

    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String userName = '';

    try {
      final user = await userDoc.get();
      final userData = user.data();

      await sharedPreferences.setString('userName', userData?['name']);

      userName = userData?['name'];
    } catch (error) {
      print(error);
    }

    return userName;
  }

  Future<List<Set<String>>> getUserTickets() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    DocumentReference<Map<String, dynamic>> userDoc =
    db.collection('users').doc('Osbm2OzwhYVd5fPFsWnHudTPezX2');

    List<Set<String>> userTickets = [];

    try {
      final user = await userDoc.get();
      final userData = user.data();

      userData?.entries.forEach((entry) {
        if ( entry.key != 'name' ) {
          userTickets.add({
            entry.key,
            entry.value
          });
        }
      });

      await sharedPreferences.setStringList('tickets', userData?['tickets']);
    } catch (error) {
      print(error);
    }

    print(userTickets);

    return userTickets;
  }

  Future<bool> generateBarcode(String storeName, String originalBarcode, String price ) async {
    bool maxAmount = false;

    int originalPrice = int.parse(getPriceFromBarcode(originalBarcode));

    String suma = ( originalPrice + int.parse(price) ).toString();
    print("original price: $originalPrice");
    print("new price: ${int.parse(price)}");
    print("sum: ${int.parse(suma)}");

    if ( int.parse(suma) > 9950 ) {
      maxAmount = true;
    } else {
      String newBarcode = '';

      if ( storeName == 'penny' ) {
        newBarcode = '2263000450910019200${suma}00';
      } else if ( storeName == 'lidl') {
        newBarcode = '2010${suma}2000000264203810';
      }

      DocumentReference<Map<String, dynamic>> userDoc =
      db.collection('users').doc('Osbm2OzwhYVd5fPFsWnHudTPezX2');

      try {
        userDoc.update({
          storeName: newBarcode
        });
      } catch (error) {
        print(error);
      }
    }

    return maxAmount;

  }

  Future<String> scanBarcode(String barcode, String storeName, String originalStoreBarcode ) async {
    String res;

    bool barcodeAlreadyUsed = await checkIfBarcodeWasAlreadyUsed(storeName, barcode);

    if ( barcodeAlreadyUsed == true ){
      res = 'BARCODE_USED';
    } else {
      String priceFromBarcode = await getPriceFromBarcode(barcode);

      bool isMaxAmount = await generateBarcode(storeName, originalStoreBarcode, priceFromBarcode);

      if ( isMaxAmount == true ) {
        res = "MAX_AMOUNT";
      } else {
        res = 'BARCODE_GOOD';
      }
    }

    return res;
  }

  String getPriceFromBarcode( String barcode ) {
    String suma = '';
    String prefix = barcode.substring(0, 4);

    if ( prefix == '2010' ) {  // lidl
      suma = barcode.substring(4, 8); // 201000002000000264203810

      // if ( suma[suma.length -2 ] == '2' ){
      //   suma = barcode.substring(3, 6);
      // }
    } else {
      barcode = barcode.substring(0, barcode.length - 2);
      suma = barcode.substring(barcode.length - 4);
    }

    return suma;
  }

  Future<bool> checkIfBarcodeWasAlreadyUsed(String storeName, String barcode) async{
    bool barcodeAlreadyUsed = false;

    DocumentReference<Map<String, dynamic>> storeDoc =
    db.collection('stores').doc(storeName);

    try {
      final store = await storeDoc.get();
      final storeData = store.data();

      storeData!.entries.forEach((element) {
        print("BARCODE ==> " + barcode);
        print("SCANNED BARCODES ==> " + element.value.toString());

        List<dynamic> values =  element.value;
        values.forEach((element) {
          print("ELEMEnT IS " + element);

          if ( element == barcode ) {
            print("barcode $barcode is already used");
            barcodeAlreadyUsed = true;
          }
        });
      });
    } catch (error) {
      print("CAUGHT AN ERROR " + error.toString());
    }

    return barcodeAlreadyUsed;
  }

  Future<void> moveBarcodeToScanned(String barcode, String storeName)  async {
    DocumentReference<Map<String, dynamic>> storeDoc =
    db.collection('stores').doc(storeName);

    try {
      await storeDoc.update({
        "scannedBarcodes": FieldValue.arrayUnion([barcode])
      });
    } catch (error) {
      print(error);
    }

  }

}