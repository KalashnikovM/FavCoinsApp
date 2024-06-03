import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../data/currency_repository/currency_repository.dart';




@RoutePage(name: 'FavoritesPage')

class FavoritesPage extends StatelessWidget with WatchItMixin{
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    CurrencyRepository repo = watchIt<CurrencyRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${repo.coinMapList.length}'),
      ),
      body: SafeArea(
        child: ListView(
          children: _widgets(repo.error),
          ),

                ),
              );
  }






  _widgets (Map<String, String> error) {

    List<Widget> widgets = [TextButton(onPressed: () {}, child: const Text("ExFunc"),),];

      error.forEach((key, value) {

        widgets.add(Padding(
            padding: const EdgeInsets.all(8),
            child: Text(key + value,),),);




      });
      return widgets;




  }


}
