import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/SL-051919-20420-09.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: _buildContent(context),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFFF6A383), // Updated app bar color
        title: Text(
          'RecycleCash',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add your settings functionality here
            },
          ),
        ],
        elevation: 5.0,
        shadowColor: Colors.black,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            // Call your barcode scanning function here
            scanBarcode(context);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(20.0), // Adjust padding to make the button bigger
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.0), // Make the button round
            ),
            backgroundColor: Color(0xFFF6A383), // Add shade to the button
            elevation: 8.0,
            shadowColor: Color(0xFFEB7749),// Adjust the elevation as needed
          ),
          child: Icon(Icons.camera_alt, size: 40.0, color: Colors.white), // Adjust size to make the icon bigger
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildUsernameBox(),
            SizedBox(height: 20.0),
            _buildShadowedSupermarketBox(context, 'Supermarket Name 1'),
            SizedBox(height: 20.0),
            _buildShadowedSupermarketBox(context, 'Supermarket Name 2'),
            SizedBox(height: 20.0),
            _buildShadowedSupermarketBox(context, 'Supermarket Name 3'),
            SizedBox(height: 20.0),
            _buildShadowedSupermarketBox(context, 'Supermarket Name 4'),
            SizedBox(height: 20.0),
            _buildShadowedSupermarketBox(context, 'Supermarket Name 5'),
            SizedBox(height: 20.0),
            _buildShadowedSupermarketBox(context, 'Supermarket Name 6'), // Added another supermarket box
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameBox() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF6A383), // Updated rectangle color
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Username',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Total Balance: \$100.00',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildShadowedSupermarketBox(BuildContext context, String supermarketName) {
    return Card(
      elevation: 10.0, // Shadow effect elevation
      shadowColor: Color(0xFF2E9A7A), // Shadow color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF36A383), // Updated rectangle color
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              supermarketName,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 0.0),
            Text(
              'Balance: \$50.00',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            SizedBox(height: 10.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showBarcodeDialog(context);
                },
                child: Text('Generate Barcode', style: TextStyle(color: Colors.black)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showBarcodeDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Barcode'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Barcode Number: 1234567890'),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          backgroundColor: Color(0xFF36A383),
        );
      },
    );
  }

  void scanBarcode(BuildContext context) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = "Failed to get platform version";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Barcode'),
          content: Text('Barcode Result: $barcodeScanRes'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
