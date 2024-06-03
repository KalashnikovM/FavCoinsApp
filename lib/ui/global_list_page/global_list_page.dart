import 'package:auto_route/annotations.dart';
import 'package:crypto_tracker/ui/custom_widgets/coin_card/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:crypto_tracker/data/currency_repository/currency_repository.dart';
import 'package:crypto_tracker/ui/top_list_page/search_page.dart';







@RoutePage(name: 'GlobalListPage')

class GlobalListPage extends StatelessWidget with WatchItMixin{
  const GlobalListPage({super.key});

  final int nextPageTrigger = 20;


  String countZerosAfterDecimal(double number) {
    String numberString = number.toString();
    int decimalIndex = numberString.indexOf('.');
    int zeroCount = 0;
    if (decimalIndex == -1) {
      return number.toString();
    }
    for (int i = decimalIndex + 1; i < numberString.length; i++) {
      if (numberString[i] == '0') {
        zeroCount++;
      } else {
        break;
      }
    }
    zeroCount = zeroCount + 2;
    return "${number.toStringAsFixed(zeroCount)}\$";
  }




  @override

  Widget build(BuildContext context) {
    CurrencyRepository repo = watchIt<CurrencyRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Global coin list"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) =>
                  const SearchPage(),
                );
              },
              icon: const Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: RefreshIndicator.adaptive(
        color: Colors.transparent,
        onRefresh: () async {
          await repo.updateMainList();
        },
        child: Stack(
          children: [
            SafeArea(
                child:
                ListView(
                 children: <Widget>[
                   ListView.builder(
                     physics: const ScrollPhysics(),
                     padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: repo.mainCoinsList.length,
                       shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index)  {
                        return
                          CoinCard(
                            model: repo.mainCoinsList[index],
                            index: index,);
                      },
                    ),


                   if(repo.mainListPageStatus == CurrencyRepositoryStatus.updated)
                   TextButton(
                     style: ElevatedButton.styleFrom(
                         foregroundColor:const Color(0xFF9b5bf3),
                      elevation: 0,
                      //   backgroundColor: Colors.purple,
                         disabledBackgroundColor:  const Color(0xFFFA2D48),
                         // shape: const CircleBorder(),
                         // fixedSize: const Size(44,44)
                     ),
                     onPressed: () => repo.updateMainList(),
                     child: const Text("Load more"),
                   ),


                 ],
               )),

            if (repo.mainListPageStatus == CurrencyRepositoryStatus.updating)
              Container(
                color: const Color(0xFF3e3e3e).withOpacity(0.15),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF9b5bf3),
                  ),
                ),
              ),


          ],
        ),
      ),

    );
  }
}
