import 'package:flutter/material.dart';
import 'package:recyclecash/widgets/logo.widget.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6D7361), // Updated background color
      appBar: AppBar(
        backgroundColor: Color(0xFF989F7E), // Updated app bar color
        title: Text(
          'Flutter App',
          style: TextStyle(color: Colors.black), // Updated title color
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFC0C7AB), // Updated rectangle color
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
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Total Balance: \$100.00', // Replace with actual balance
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              _buildSupermarketBox(context, 'Supermarket Name 1'),
              SizedBox(height: 20.0),
              _buildSupermarketBox(context, 'Supermarket Name 2'),
              SizedBox(height: 20.0),
              _buildSupermarketBox(context, 'Supermarket Name 3'),
              SizedBox(height: 20.0),
              _buildSupermarketBox(context, 'Supermarket Name 4'), // Added another supermarket box
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your scan button functionality here
        },
        label: Text('SCAN', style: TextStyle(color: Colors.black)), // Updated button text color
        backgroundColor: Color(0xFFC0C7AB), // Updated button color
        icon: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSupermarketBox(BuildContext context, String supermarketName) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFB6AD90), // Updated rectangle color
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            supermarketName,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Balance: \$50.00', // Replace with actual balance
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              // Add your barcode generation functionality here
              _showBarcodeDialog(context);
            },
            child: Text('Generate Barcode', style: TextStyle(color: Colors.black)), // Updated button text color
          ),
        ],
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
              Text('Barcode Number: 1234567890'), // Replace with actual barcode number
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close', style: TextStyle(color: Colors.black)), // Updated button text color
              ),
            ],
          ),
          backgroundColor: Color(0xFFC0C7AB), // Updated dialog background color
        );
      },
    );
  }
}


