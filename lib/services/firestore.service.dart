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

  Future<List<Barcode>> getUserTicketsForStore(
      String userID, String storeName) async {
    List<Barcode> userTickets = [];

    QuerySnapshot<Map<String, dynamic>> snapshot;
    snapshot =
        await db.collection('users').doc(userID).collection(storeName).get();
    snapshot.docs.forEach((element) {
      if  (element.data()["used"] == false) {
        userTickets.add(Barcode.fromEntry(element.id, element.data()));
      }
    });

    return userTickets;
  }

  Future<Map<String, List<Barcode>>> getUserTickets(String userID) async {
    Map<String, List<Barcode>> userTickets = {};
    userTickets['lidl'] = await getUserTicketsForStore(userID, 'lidl');
    userTickets['penny'] = await getUserTicketsForStore(userID, 'penny');
    userTickets['megaimage'] =
        await getUserTicketsForStore(userID, 'megaimage');
    return userTickets;
  }

  Future<bool> saveBarCode(String userId, Barcode barcode) async {
    await db
        .collection('users')
        .doc(userId)
        .collection(barcode.storeName.name)
        .doc(barcode.barcode)
        .set(barcode.toMap());
    return true;
  }

  Future<bool> checkIfBarcodeWasAlreadyUsed(
      String userId, String storeName, String barcode) async {
    bool barcodeAlreadyUsed = false;

    DocumentSnapshot<Map<String, dynamic>> doc = await db
        .collection('users')
        .doc(userId)
        .collection(storeName)
        .doc(barcode)
        .get();
    if (doc.exists) {
      barcodeAlreadyUsed = true;
    }
    return barcodeAlreadyUsed;
  }

  Future<void> moveBarcodeToScanned(String barcode, String storeName) async {
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

    QuerySnapshot<Map<String, dynamic>> collection = await db.collection("users").doc(userId).collection(storeName).get();
    // update the used property to false
    collection.docs.forEach((element) {
      db.collection("users").doc(userId).collection(storeName).doc(element.id).update({
        "used": true
      });
    });

  }

  Future<void> updateBarcode(
      String userId, String storeName, String newBarcode) async {
    DocumentReference<Map<String, dynamic>> userDoc =
        db.collection('users').doc(userId);

    try {
      await userDoc.update({storeName: newBarcode});
    } catch (error) {
      print(error);
      // Handle error
    }
  }
}
