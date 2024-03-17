
enum BarcodeStore {
  lidl,
  kaufland,
  profi,
  megaImage,
  carrefour,
  undefined;

  static BarcodeStore fromString(String  storeName) {
    switch (storeName) {
      case 'lidl':
        return BarcodeStore.lidl;
      case 'kaufland':
        return BarcodeStore.kaufland;
      case 'profi':
        return BarcodeStore.profi;
      case 'megaImage':
        return BarcodeStore.megaImage;
      case 'carrefour':
        return BarcodeStore.carrefour;
      default:
        return BarcodeStore.undefined;
    }
  }

  String toString() {
    switch (this) {
      case BarcodeStore.lidl:
        return 'lidl';
      case BarcodeStore.kaufland:
        return 'kaufland';
      case BarcodeStore.profi:
        return 'profi';
      case BarcodeStore.megaImage:
        return 'megaImage';
      case BarcodeStore.carrefour:
        return 'carrefour';
      default:
        return 'undefined';
    }
  }
}
class Barcode {
  final String barcode;
  BarcodeStore store = BarcodeStore.undefined;
  int price = 0;

  Barcode({required this.barcode, this.store = BarcodeStore.undefined, this.price = 0}) {
    String prefix = barcode.substring(0, 4);

    if ( prefix == '2010' ) {  // lidl
      price = int.parse(barcode.substring(4, 8));
      store = BarcodeStore.lidl;
    } else {
      // barcode = barcode.substring(0, barcode.length - 2);
      price = int.parse(barcode.substring(barcode.length - 4));
    }
  }

  static Barcode fromEntry(String key, value) {
    return Barcode(barcode: value, store: BarcodeStore.fromString(key));
  }

  static Barcode dummyBarcode(String storeName) {
    return Barcode(barcode: '201099992000000264203810', store: BarcodeStore.fromString(storeName), price: 0);
  }

}