import 'package:auto_route/annotations.dart';
import 'package:crypto_tracker/ui/custom_widgets/coin_card/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../../data/currency_repository/currency_repository.dart';






@RoutePage(name: 'Top100ListPage')
class Top100ListPage extends StatelessWidget with WatchItMixin {
  const Top100ListPage({super.key});

  static ScrollController scrollController = ScrollController();
  price(String text, double data) {
    return Text(
      "$text ${data.toStringAsFixed(2)}%",
      style: TextStyle(
        color: data.isNegative ? Colors.red : Colors.green,
      ),
    );
  }

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
    return "${number.toStringAsFixed(zeroCount)} \$";
  }


  static const TextStyle style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16
  );




  @override
  Widget build(BuildContext context) {
    CurrencyRepository repo = watchIt<CurrencyRepository>();

    return Scaffold(
      body: RefreshIndicator.adaptive(
           color: Colors.transparent,
          onRefresh: () async {
            await repo.getLastCurrencyRateList();
          },
          child: Stack(
              children: [
                SafeArea(
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverAppBar(
                        floating: true,
                         snap: false,
                        pinned: true,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0),
                            child: IconButton(
                              onPressed: () {},


                              // {
                              //   showModalBottomSheet(
                              //     backgroundColor: Colors.transparent,
                              //     isScrollControlled: true,
                              //     context: context,
                              //     builder: (BuildContext context) =>
                              //     const SearchPage(),
                              //   );
                              // },
                              icon: const Icon(Icons.search,
                              ),
                            ),
                          ),
                        ],
                        leading: repo.top100Stream
                            ? const Icon(Icons.circle, )
                            : const Icon(Icons.circle_outlined),
                        title: const Text("Top 100 market cap."),
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

                                Text("Pair", style: style,),
                                Expanded(
                                  child: SizedBox(),),


                                Text("Price  \$", style: style,),

                              ],
                            ),
                          )
                        ),
                      ),




                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return CoinCard(
                              model: repo.top100ModelsList[index],
                              index: index,);
                          },
                          childCount: repo.top100ModelsList.length,
                        ),
                      ),
                    ],
                  ),
                ),
                if (repo.top100PageStatus == CurrencyRepositoryStatus.updating)
                  Container(
                    color: const Color(0xFF3e3e3e).withOpacity(0.15),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF9b5bf3),
                      ),
                    ),
                  ),
              ]
          )
      ),
    );
  }
}