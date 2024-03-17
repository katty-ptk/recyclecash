import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:recyclecash/data/Barcode.dart';
import 'package:recyclecash/screens/home/home.provider.dart';
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
            scanBarcode(context, state.userTickets, state.barcodeScanned);
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
    List<Barcode> userTickets,
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
    List<Barcode> userTickets,
    Function(Barcode) undoBarcode,
  ) {
    List<Widget> contentChildren = [];

    contentChildren.add(_buildUsernameBox(username, userTickets));
    contentChildren.add(
      const SizedBox(height: 20.0),
    );

    for (var ticket in userTickets) {
      // String balance = FirestoreService().getPriceFromBarcode(ticket);
      String balance = "${ticket.price}";

      contentChildren.add(
        _buildShadowedSupermarketBox(
          context,
          ticket,
          double.parse(balance),
          'assets/${ticket.store.toString()}.jpg',
          userTickets,
          undoBarcode,
        ),
      );
    }

    contentChildren.add(
      _buildShadowedSupermarketBox(
        context,
        Barcode.dummyBarcode('Profi'),
        0.0,
        'assets/profi.jpg',
        userTickets,
        undoBarcode,
      ),
    );

    contentChildren.add(
      _buildShadowedSupermarketBox(
        context,
        Barcode.dummyBarcode('Mega Image'),
        0.0,
        'assets/megaimage.jpg',
        userTickets,
        undoBarcode,
      ),
    );

    contentChildren.add(
      _buildShadowedSupermarketBox(
        context,
        Barcode.dummyBarcode('Carrefour'),
        0.0,
        'assets/carrefour.jpg',
        userTickets,
        undoBarcode,
      ),
    );

    contentChildren.add(
      _buildShadowedSupermarketBox(
        context,
        Barcode.dummyBarcode('Kaufland'),
        0.0,
        'assets/kaufland.jpg',
        userTickets,
        undoBarcode,
      ),
    );

    return contentChildren;
  }

  Widget _buildUsernameBox(String username, List<Barcode> userTickets) {
    // FirestoreService().getPriceFromBarcode(userTickets[0].last) + FirestoreService().getPriceFromBarcode(userTickets[1].last)

    // double first = double.parse(
    //     FirestoreService().getPriceFromBarcode(userTickets[0].last));
    // double second = double.parse(
    //     FirestoreService().getPriceFromBarcode(userTickets[1].last));
    int first = userTickets[0].price;
    int second = userTickets[1].price;

    double sum = (first + second) / 100;

    print("FIRST DOUBLE IS ==> " + first.toString());

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
    Barcode barcode,
    double balance,
    String imagePath,
    List<Barcode> userTickets,
    Function(Barcode) undoBarcode,
  ) {
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
                    barcode.store.toString().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Balance: \$${(balance / 100).toString()}',
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _showBarcodeDialog(context, barcode, undoBarcode);
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
    // List<Set<String>> userTickets =
    //     await FirestoreService().getUserTickets('Osbm2OzwhYVd5fPFsWnHudTPezX2');

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

  void scanBarcode(
      BuildContext context,
      List<Barcode> userTickets,
      Future<String> Function(String, String, Barcode) barcodeScanned,
      ) async {
    String barcodeScanRes;
    String result = '';

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "cancel", true, ScanMode.BARCODE);

      String storeName =
          barcodeScanRes.substring(0, 4) == '2263' ? 'penny' : 'lidl';
      Barcode originalBarcode = userTickets.firstWhere(
        (element) => element.store.toString() == storeName,
        orElse: () => Barcode(
          barcode: barcodeScanRes,
          store: BarcodeStore.fromString(storeName),
        ),
      );
      // storeName == 'penny' ? userTickets[1].last : userTickets[0].last;

      // result = await FirestoreService()
      //     .scanBarcode(barcodeScanRes, storeName, originalBarcode);
      result = await barcodeScanned(barcodeScanRes, storeName, originalBarcode);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('Barcode Result')),
            content: Text(
              result == 'BARCODE_GOOD'
                  ? 'Good Job on recycling! ♻️'
                  : (result == 'BARCODE_USED'
                      ? 'This barcode has already been scanned!'
                      : 'You have reached the maximum amount!'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28,
                  color: result == 'BARCODE_GOOD' ? Colors.green : Colors.red),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  await FirestoreService()
                      .moveBarcodeToScanned(barcodeScanRes, storeName);
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
          state.userTickets,
          state.undoBarcode,
        ),
      );
    }
  }
}
