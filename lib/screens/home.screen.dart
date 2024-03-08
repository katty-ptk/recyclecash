import 'package:flutter/material.dart';
import 'package:recyclecash/widgets/logo.widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: RecycleCashLogo(),
      ),
    );
  }
}
