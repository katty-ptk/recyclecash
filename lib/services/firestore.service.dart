import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recyclecash/data/Barcode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;

  Future<String> getUserName(String userId) async {
    DocumentReference<Map<String, dynamic>> userDoc =
    db.collection('users').doc(userId);

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

  Future<List<Barcode>> getUserTickets(String userID) async {

    DocumentReference<Map<String, dynamic>> userDoc =
    db.collection('users').doc(userID);

    List<Barcode> userTickets = [];

    try {
      final user = await userDoc.get();
      final userData = user.data();

      userData?.entries.forEach((entry) {
        if ( entry.key != 'name' ) {
          userTickets.add(Barcode.fromEntry(entry.key, entry.value));
        }
      });

    } catch (error) {
      print(error);
    }

    print(userTickets);

    return userTickets;
  }

  Future<bool> saveBarCode(String userId, String storeName ) async {
    DocumentReference<Map<String, dynamic>> userDoc =
    db.collection('users').doc(userId);

    try {
      userDoc.update({
        storeName: storeName
      });
    } catch (error) {
      print(error);
      return false;
    }
    return true;
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

  Future<void> undoBarcode(String userId, String storeName) async {
    DocumentReference<Map<String, dynamic>> userDoc =
    db.collection('users').doc(userId);

    String barcode = '';

    if ( storeName == 'lidl' ) {
      barcode = '20101000000000264203810';
    } else {
        barcode = '226300045091001920000000';
    }

    try {
      print("sunt in try");

      await userDoc.update({
        storeName: barcode
      });
    } catch (error) {
      print(error);
    }
  }

}