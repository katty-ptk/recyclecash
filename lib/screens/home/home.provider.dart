import 'package:flutter/cupertino.dart';
import 'package:recyclecash/data/Barcode.dart';
import 'package:recyclecash/screens/home/uiStoreBarcode.dart';
import 'package:recyclecash/services/auth.service.dart';
import 'package:recyclecash/services/firestore.service.dart';

class HomeProvider extends ChangeNotifier {
  bool isLoading = false;
  String userName = "";
  String userId = "";
  List<UiStoreBarcode> uiBarcodes = [];

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
    await refreshTickets();
    isLoading = false;
    notifyListeners();
  }

  undoBarcode(Barcode barcodeToUndo) async {
    isLoading = true;
    notifyListeners();

    await _firestoreService.undoBarcode(
      userId,
      barcodeToUndo.storeName.toString(),
    );
    await refreshTickets();

    isLoading = false;
    notifyListeners();
  }

  Future<String> barcodeScanned(
    String barcode,
  ) async {
    String res;
    Barcode originalStoreBarcode = Barcode(barcode: barcode);

    try {
      bool barcodeAlreadyUsed =
          await _firestoreService.checkIfBarcodeWasAlreadyUsed(
              userId, originalStoreBarcode.storeName.name, barcode);

      if (barcodeAlreadyUsed == true) {
        res = 'BARCODE_USED';
      } else {
        getPriceFromBarcode(barcode);

        await _firestoreService.saveBarCode(userId, originalStoreBarcode);
        await refreshTickets();
        res = 'BARCODE_GOOD';
      }
    } catch (e) {
      res = 'BARCODE_ERROR';
    }
    return res;
  }

  // Future<bool> generateBarcode(
  //   String storeName,
  //   String originalBarcode,
  //   String price,
  // ) async {
  //   bool maxAmount = false;
  //
  //   int originalPrice = int.parse(getPriceFromBarcode(originalBarcode));
  //
  //   String suma = (originalPrice + int.parse(price)).toString();
  //   print("original price: $originalPrice");
  //   print("new price: ${int.parse(price)}");
  //   print("sum: ${int.parse(suma)}");
  //
  //   if (int.parse(suma) > 9950) {
  //     maxAmount = true;
  //   } else {
  //     String newBarcode = '';
  //
  //     if (storeName == 'penny') {
  //       newBarcode = '2263000450910019200${suma}00';
  //     } else if (storeName == 'lidl') {
  //       newBarcode = '2010${suma}2000000264203810';
  //     }
  //     await _firestoreService.updateBarcode(userId, storeName, newBarcode);
  //   }
  //
  //   return maxAmount;
  // }

  String getPriceFromBarcode(String barcode) {
    String suma = '';
    String prefix = barcode.substring(0, 4);

    if (prefix == '2010') {
      // lidl
      suma = barcode.substring(4, 8);
    } else {
      barcode = barcode.substring(0, barcode.length - 2);
      suma = barcode.substring(barcode.length - 4);
    }

    return suma;
  }

  void generateUIBarcodes(Map<String, List<Barcode>> userTickets) {
    uiBarcodes = [];
    userTickets.forEach((key, value) {
        uiBarcodes.add(UiStoreBarcode(
            storeName: key,
            storeBarcode: generateStoreBarcode(value, key),
            allBarcodes: value));
    });
  }

  Barcode generateStoreBarcode(List<Barcode> element, String storeName) {
    double sum = 0;
    element.forEach((element) {
      sum += element.value;
    });

    if ( sum > 0 ) {
      return Barcode.injectNewValue(element[0], sum);
    } else {
      return Barcode.dummyBarcode(storeName);
    }
  }

  Future refreshTickets() async {
    var userTickets = await _firestoreService.getUserTickets(userId);
    generateUIBarcodes(userTickets);
    notifyListeners();
  }
}
