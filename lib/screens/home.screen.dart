import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:recyclecash/screens/profile.screen.dart';
import 'package:recyclecash/services/firestore.service.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    @override
  Widget build(BuildContext context) {

    String userName = '';
    List<Set<String>> userTickets = [];

    Future<void> getData() async {
      userName = await FirestoreService().getUserName();
      userTickets = await FirestoreService().getUserTickets();
    }

    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if ( snapshot.connectionState == ConnectionState.waiting ) {
            return Center(child: CircularProgressIndicator());
          }

          if ( snapshot.connectionState == ConnectionState.done ){
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/SL-051919-20420-09.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: _buildContent(context, userName, userTickets),
            );
          }

          return CircularProgressIndicator();
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFF6A383), // Updated app bar color
        title: Text(
          'RecycleCash',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_sharp, color: Colors.white,),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ProfileScreen(userName: userName,))
              );
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
            scanBarcode(context, userTickets);
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

  Widget _buildContent(BuildContext context, String username, List<Set<String>> userTickets) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buildContentChildren(context, username, userTickets),
        ),
      ),
    );
  }

  List<Widget> buildContentChildren(BuildContext context, String username, List<Set<String>> userTickets) {
    List<Widget> contentChildren = [];

    contentChildren.add(_buildUsernameBox(username));
    contentChildren.add(SizedBox(height: 20.0),);

    userTickets.forEach((ticket) {
      String balance = FirestoreService().getPriceFromBarcode(ticket.last);

      contentChildren.add(
      _buildShadowedSupermarketBox(context, ticket.first, double.parse(balance)),
      );
    });

    return contentChildren;
  }

  Widget _buildUsernameBox(String username) {
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
            '$username',
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

  Widget _buildShadowedSupermarketBox(BuildContext context, String supermarketName, double balance) {
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
              'Balance: \$${(balance/100).toString()}',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            SizedBox(height: 10.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showBarcodeDialog(context, supermarketName);
                },
                child: Text('Generate Barcode', style: TextStyle(color: Colors.black)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showBarcodeDialog(BuildContext context, String storeName) async {
    List<Set<String>> userTickets = await FirestoreService().getUserTickets();
    String barcode = storeName == 'lidl' ? userTickets[0].last : userTickets[1].last;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Barcode'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 150,
                child: SfBarcodeGenerator(
                    value: barcode,
                  showValue: true,
                  symbology: Code128(),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
      },
    );
  }

  void scanBarcode(BuildContext context, List<Set<String>> userTickets ) async {
    String barcodeScanRes;
    String result = '';

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "cancel", true, ScanMode.BARCODE);

      String storeName = barcodeScanRes.substring(0, 4) == '2263' ? 'penny' : 'lidl';
      String originalBarcode = storeName == 'penny' ? userTickets[1].last : userTickets[0].last;

     result = await FirestoreService().scanBarcode(barcodeScanRes, storeName, originalBarcode);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('Barcode Result')),
            content: Text(
              result == 'BARCODE_GOOD'
                  ? 'Good Job on recycling! ♻️'
                  : (
                    result == 'BARCODE_USED'
                      ? 'This barcode has already been scanned!'
                      : 'You have reached the maximum amount!'
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28,
                  color: result == 'BARCODE_GOOD' ? Colors.green : Colors.red
              ),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {

                  });
                },
                icon: Icon(Icons.check_circle, color: result == 'BARCODE_GOOD' ? Colors.green : Colors.red, size: 32,),
              ),
            ],
          );
        },
      );

    } on PlatformException {
      barcodeScanRes = "Failed to get platform version";
    }
  }
}
