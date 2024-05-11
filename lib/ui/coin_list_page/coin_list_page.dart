import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';




@RoutePage(name: 'CoinListPage')

class CoinListPage extends StatelessWidget {
  const CoinListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text('CoinListPage'),
            )
          ],
        ),
      ),
    );
  }
}
