import 'package:cloud_firestore/cloud_firestore.dart';

enum BarcodeStore {
  lidl,
  kaufland,
  profi,
  megaimage,
  carrefour,
  penny,
  undefined;

  static BarcodeStore fromString(String storeName) {
    switch (storeName) {
      case 'lidl':
        return BarcodeStore.lidl;
      case 'kaufland':
        return BarcodeStore.kaufland;
      case 'profi':
        return BarcodeStore.profi;
      case 'megaimage':
        return BarcodeStore.megaimage;
      case 'carrefour':
        return BarcodeStore.carrefour;
      case 'penny':
        return BarcodeStore.penny;
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
      case BarcodeStore.megaimage:
        return 'megaimage';
      case BarcodeStore.carrefour:
        return 'carrefour';
      case BarcodeStore.penny:
        return 'penny';
      default:
        return 'undefined';
    }
  }
}
String LIDL_PREFIX =  '2010';
String PENNY_PREFIX = '2263';
String MEGAIMAGE_PREFIX = '9800';

class Barcode {
  final String barcode;
  BarcodeStore storeName = BarcodeStore.undefined;
  double value = 0.0;
  Timestamp scanDate = Timestamp.now();
  bool used = false;

  Barcode(
      {required this.barcode,
      this.storeName = BarcodeStore.undefined,
      this.value = 0.0,
      this.used = false,
      Timestamp? scanDate}) {
    if (scanDate != null) {
      this.scanDate = scanDate;
    }

    String prefix = barcode.substring(0, 4);
    if (prefix == LIDL_PREFIX) {
      // lidl
      value = double.parse(barcode.substring(4, 8)) / 100;
      storeName = BarcodeStore.lidl;
    } else if (prefix == PENNY_PREFIX) {
      // penny
      storeName = BarcodeStore.penny;
      value = double.parse(
              barcode.substring(barcode.length - 6, barcode.length - 2)) /
          100;
    } else if (prefix == MEGAIMAGE_PREFIX) {
      // megaimage
      storeName = BarcodeStore.megaimage;
      value = double.parse(
              barcode.substring(barcode.length - 7, barcode.length - 3)) /
          100;
    }
  }

  static Barcode injectNewValue(Barcode barcode, double newValue) {
    // value looks like this: 12,23; 0.5; 1
    String valueToInsert = (newValue * 10).toInt().toString();
    if (valueToInsert.length == 1) {
      // 0.5 -> 0050
      valueToInsert = '00${valueToInsert}0';
    } else if (valueToInsert.length == 2) {
      // 1.5 -> 0150
      valueToInsert = '0${valueToInsert}0';
    } else if (valueToInsert.length == 3) {
      // 12.5 -> 1250
      valueToInsert = '${valueToInsert}0';
    }
    String newBarcode = barcode.barcode;
    if (barcode.storeName.name == 'lidl') {
      newBarcode = barcode.barcode.replaceRange(4, 8, valueToInsert);
    } else if (barcode.storeName.name == 'penny') {
      newBarcode = barcode.barcode.replaceRange(barcode.barcode.length - 6,
          barcode.barcode.length - 2, valueToInsert);
    } else if (barcode.storeName.name == 'megaimage') {
      newBarcode = barcode.barcode.replaceRange(barcode.barcode.length - 7,
          barcode.barcode.length - 3, valueToInsert);
    }

    return Barcode(
        barcode: newBarcode,
        storeName: barcode.storeName,
        value: newValue,
        used: barcode.used,
        scanDate: barcode.scanDate);
  }

  static Barcode fromEntry(String key, Map<String, dynamic> value) {
    return Barcode(
        barcode: value["barcode"],
        storeName: BarcodeStore.fromString(value["storename"]),
        value: value["value"].toDouble(),
        used: value["used"],
        scanDate: value["scan_date"]);
  }

  static Barcode dummyBarcode(String storeName) {
    if (storeName == LIDL_PREFIX) {
      return Barcode(
          barcode: '201000002000000264203810',
          storeName: BarcodeStore.fromString(storeName),
          value: 0);
    } else if (storeName == PENNY_PREFIX) {
      return Barcode(
          barcode: '226399992000000264000010',
          storeName: BarcodeStore.fromString(storeName),
          value: 0);
    } else if (storeName == MEGAIMAGE_PREFIX) {
      return Barcode(
          barcode: '980099992000000260000810',
          storeName: BarcodeStore.fromString(storeName),
          value: 0);
    }

    return Barcode(
        barcode: '201099992000000264203810',
        storeName: BarcodeStore.fromString(storeName),
        value: 0);
  }

  Map<String, dynamic> toMap() {
    return {
      "barcode": barcode,
      "storename": storeName.toString(),
      "value": value,
      "used": used,
      "scan_date": scanDate
    };
  }
}
