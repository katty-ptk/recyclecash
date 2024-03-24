import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recyclecash/data/Barcode.dart';
import 'package:recyclecash/screens/home/home.provider.dart';
import 'package:recyclecash/screens/home/uiStoreBarcode.dart';
import 'package:recyclecash/screens/login/login.screen.dart';
import 'package:recyclecash/services/auth.service.dart';
import 'package:recyclecash/services/firestore.service.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) {
      return HomeProvider(
        firestoreService: FirestoreService(),
        authService: AuthService(),
      );
    }, child: Consumer<HomeProvider>(
      builder: (context, state, _) {
        return buildHomeScaffold(context, state);
      },
    ));
  }

  Widget buildHomeScaffold(BuildContext context, HomeProvider state) {
    return Scaffold(
      body: buildScaffoldBody(context, state),
      appBar: AppBar(
        backgroundColor: const Color(0xFF595959),
        // Updated app bar color
        automaticallyImplyLeading: false,
        title: const Text(
          'RecycleCash',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
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
            scanBarcode(context, state.uiBarcodes, state.barcodeScanned);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20.0),
            // Adjust padding to make the button bigger
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(60.0), // Make the button round
            ),
            backgroundColor: const Color(0xFF595959),
            // Add shade to the button
            elevation: 8.0,
            shadowColor:
                const Color(0xFF595959), // Adjust the elevation as needed
          ),
          child: const Icon(Icons.camera_alt,
              size: 40.0,
              color: Colors.white), // Adjust size to make the icon bigger
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildContent(
    BuildContext context,
    String username,
    List<UiStoreBarcode> userTickets,
    Function(Barcode) undoBarcode,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              buildContentChildren(context, username, userTickets, undoBarcode),
        ),
      ),
    );
  }

  List<Widget> buildContentChildren(
    BuildContext context,
    String username,
    List<UiStoreBarcode> userTickets,
    Function(Barcode) undoBarcode,
  ) {
    List<Widget> contentChildren = [];

    double sum = 0.0;
    for (var element in userTickets) {
      for (var ticket in element.allBarcodes) {
        sum += ticket.value;
      }
    }

    contentChildren.add(_buildUsernameBox(username, sum));
    contentChildren.add(
      const SizedBox(height: 20.0),
    );

    for (var ticket in userTickets) {
      contentChildren.add(
        _buildShadowedSupermarketBox(
          context,
          ticket.storeName,
          'assets/${ticket.storeName.toString()}.jpg',
          ticket,
          undoBarcode,
        ),
      );
    }
    return contentChildren;
  }

  Widget _buildUsernameBox(String username, double sum) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF595959).withAlpha(60), // Updated rectangle color
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Total Balance: \$${sum.toString()}',
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildShadowedSupermarketBox(
    BuildContext context,
    String storename,
    String imagePath,
    UiStoreBarcode userTicket,
    Function(Barcode) undoBarcode,
  ) {
    double balance = 0;
    for (var ticket in userTicket.allBarcodes) {
      balance += ticket.value;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 15),
      elevation: 10.0,
      // Shadow effect elevation
      shadowColor: Color(0xFF2E9A7A).withAlpha(50),
      // Shadow color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF36A383).withAlpha(50), // Updated rectangle color
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storename.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Balance: \$${(balance).toString()}',
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _BarcodesDialog(
                          context,
                          userTicket,
                          undoBarcode,
                        );
                      },
                      child: const Text('Generate Barcode',
                          style: TextStyle(color: Colors.black)),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Add some spacing between supermarket name and image
            Image.asset(
              imagePath,
              width: 100, // Adjust the width of the image
              height: 100, // Adjust the height of the image
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBarcodeDialog(
    BuildContext context,
    Barcode barcode,
    Function(Barcode) undoBarcode,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Barcode',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 150,
                child: SfBarcodeGenerator(
                  value: barcode.barcode,
                  showValue: true,
                  symbology: Code128(),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  // await FirestoreService().undoBarcode(storeName);
                  undoBarcode(barcode);
                },
                child:
                    const Text('Close', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _BarcodesDialog(
    BuildContext context,
    UiStoreBarcode barcode,
    Function(Barcode) undoBarcode,
  ) async {
    List<Widget> actions = [];
    if ( barcode.storeBarcode.value > 0.0 ) {
      actions.add(Center(
        child: ElevatedButton(
          onPressed: () async {
            _showBarcodeDialog(
                context, barcode.storeBarcode, undoBarcode);
          },
          child: const Text('Generate Barcode',
              style: TextStyle(color: Colors.black)),
        ),
      ));
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Barcodes',
            textAlign: TextAlign.center,
          ),
          content: Container(
            width: double.maxFinite,
            height: barcode.allBarcodes.length > 4
                ? 440
                : barcode.allBarcodes.length * 110,
            child: ListView.builder(
              itemCount: barcode.allBarcodes.length,
              scrollDirection: Axis.vertical,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 10 : 5,
                    right: index == 4 ? 10 : 5,
                    top: 10
                  ),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat('yyyy-MM-dd – kk:mm').format(barcode.allBarcodes[index].scanDate.toDate()),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 60,
                          child: SfBarcodeGenerator(
                            value: barcode.allBarcodes[index].barcode,
                            showValue: false,
                            symbology: Code128(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: actions,
        );
      },
    );
  }

  void scanBarcode(
    BuildContext context,
    List<UiStoreBarcode> userTickets,
    Future<String> Function(String) barcodeScanned,
  ) async {
    String barcodeScanRes;
    String result = '';

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "cancel", true, ScanMode.BARCODE);

      result = await barcodeScanned(barcodeScanRes);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Barcode Result')),
            content: Text(
              result == 'BARCODE_GOOD'
                  ? 'Good Job on recycling! ♻️'
                  : (result == 'BARCODE_USED'
                      ? 'This barcode has already been scanned!'
                      : 'Error scanning barcode! Please try again. 🤖'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28,
                  color: result == 'BARCODE_GOOD' ? Colors.green : Colors.red),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  // await FirestoreService()
                  //     .moveBarcodeToScanned(barcodeScanRes, storeName);
                },
                icon: Icon(
                  Icons.check_circle,
                  color: result == 'BARCODE_GOOD' ? Colors.green : Colors.red,
                  size: 32,
                ),
              ),
            ],
          );
        },
      );
    } on PlatformException {
      barcodeScanRes = "Failed to get platform version";
    }
  }

  Widget buildScaffoldBody(BuildContext context, HomeProvider state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/SL-051919-20420-09.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: _buildContent(
          context,
          state.userName,
          state.uiBarcodes,
          state.undoBarcode,
        ),
      );
    }
  }
}
