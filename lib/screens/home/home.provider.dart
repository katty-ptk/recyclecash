import 'package:flutter/cupertino.dart';
import 'package:recyclecash/data/Barcode.dart';
import 'package:recyclecash/services/auth.service.dart';
import 'package:recyclecash/services/firestore.service.dart';

class HomeProvider extends ChangeNotifier {
  bool isLoading = false;
  String userName = "";
  String userId = "";
  List<Barcode> userTickets = [];

  FirestoreService _firestoreService;
  AuthService _authService;

  HomeProvider(
      {required FirestoreService firestoreService,
      required AuthService authService})
      : _firestoreService = firestoreService,
        _authService = authService {
    getUserData();
  }

  getUserData() async {
    isLoading = true;
    notifyListeners();
    userId = await _authService.getUserId();
    userName = await _firestoreService.getUserName(userId);
    userTickets = await _firestoreService.getUserTickets(userId);
    isLoading = false;
    notifyListeners();
  }

  undoBarcode(Barcode barcodeToUndo) async {

    isLoading = true;
    notifyListeners();

    await _firestoreService.undoBarcode(userId, barcodeToUndo.store.toString());

    userTickets = await _firestoreService.getUserTickets(userId);

    isLoading = false;
    notifyListeners();
  }


  Future<String> barcodeScanned(String barcode, String storeName, Barcode originalStoreBarcode ) async {
    String res;

    bool barcodeAlreadyUsed = await _firestoreService.checkIfBarcodeWasAlreadyUsed(storeName, barcode);

    if ( barcodeAlreadyUsed == true ){
      res = 'BARCODE_USED';
    } else {
      String priceFromBarcode = getPriceFromBarcode(barcode);

      bool isMaxAmount = await generateBarcode(storeName, originalStoreBarcode.barcode, priceFromBarcode);

      if ( isMaxAmount == true ) {
        res = "MAX_AMOUNT";
      } else {
        res = 'BARCODE_GOOD';
      }
    }

    return res;
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

      if (storeName == 'penny') {
        newBarcode = '2263000450910019200${suma}00';
      } else if (storeName == 'lidl') {
        newBarcode = '2010${suma}2000000264203810';
      }
      await _firestoreService.updateBarcode(userId,storeName, newBarcode);
    }

    return maxAmount;

  }

  String getPriceFromBarcode( String barcode ) {
    String suma = '';
    String prefix = barcode.substring(0, 4);

    if ( prefix == '2010' ) {  // lidl
      suma = barcode.substring(4, 8);
    } else {
      barcode = barcode.substring(0, barcode.length - 2);
      suma = barcode.substring(barcode.length - 4);
    }

    return suma;
  }

}
