import 'package:auto_route/annotations.dart';
import 'package:crypto_tracker/ui/custom_widgets/coin_card/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../data/currency_repository/global_repository/global_repository.dart';
import 'search_page.dart';







@RoutePage(name: 'GlobalListPage')

class GlobalListPage extends StatelessWidget with WatchItMixin{
  const GlobalListPage({super.key});

  static ScrollController scrollController = ScrollController();


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


  static const TextStyle style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16
  );

  @override

  Widget build(BuildContext context) {
    debugPrint('build GlobalListPage');

    GlobalListRepository repo = watchIt<GlobalListRepository>();

    return RefreshIndicator.adaptive(
      color: Colors.transparent,

      onRefresh: () async {
        await repo.updateMainList();
      },
      child: Stack(
        children: [
          Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  const SliverAppBar(
                    floating: true,
                    snap: false,
                    pinned: true,
                    title: Text("Global coin list"),
                  ),


                  const SliverToBoxAdapter(
                    child: SizedBox(
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 32),
                                child: Text("Rate", style: style,),
                              ),

                              Text("Ticker/Name", style: style,),
                              Expanded(
                                child: SizedBox(),),


                              Text("Price  USD", style: style,),

                            ],
                          ),
                        )
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return CoinCard(
                          model: repo.mainCoinsList[index],
                          index: index,);
                      },
                      childCount: repo.mainCoinsList.length,
                    ),
                  ),

                  if(repo.globalListRepositoryStatus == GlobalListRepositoryStatus.updated)
                    SliverToBoxAdapter(
                      child: TextButton(
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
                    ),

                ],
              ),
            ),
          ),


          if (repo.globalListRepositoryStatus == GlobalListRepositoryStatus.updating)
            Container(
              color: const Color(0xFF3e3e3e).withOpacity(0.2),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFFA2D48),
                ),
              ),
            ),


        ],
      ),
    );
  }
}
