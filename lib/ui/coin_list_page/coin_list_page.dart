import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../data/currency_repository/currency_repository.dart';




@RoutePage(name: 'CoinListPage')

class CoinListPage extends StatelessWidget with WatchItMixin{
  const CoinListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> repo = watchIt<CurrencyRepository>().error;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: _widgets(repo),
          ),

                ),
              );
  }






  _widgets (Map<String, String> error) {

    List<Widget> widgets = [];

      error.forEach((key, value) {

        widgets.add(Padding(
            padding: const EdgeInsets.all(8),
            child: Text(key + value,),),);




      });
      return widgets;




  }


}
