import 'package:recyclecash/data/Barcode.dart';

class UiStoreBarcode {
  String storeName = "";
  Barcode storeBarcode;
  List<Barcode> allBarcodes = [];

  UiStoreBarcode({
    required this.storeName,
    required this.storeBarcode,
    required this.allBarcodes,
  });
}
