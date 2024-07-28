import 'package:auto_route/annotations.dart';
import 'package:crypto_tracker/ui/custom_widgets/coin_card/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../../app_colors.dart';
import '../../data/currency_repository/top_repository/top_repository.dart';






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
    debugPrint('build Top100ListPage');

    Top100Repository repo = watchIt<Top100Repository>();

    return Stack(
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
                  title: Text("Top 100 market cap."),
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
                        model: repo.top100ModelsList[index],
                        index: index,);
                    },
                    childCount: repo.top100ModelsList.length,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (repo.top100RepositoryStatus == Top100RepositoryStatus.updating)
          Container(
            color: const Color(0xFF3e3e3e).withOpacity(0.2),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.mainGreen,
              ),
            ),
          ),
      ],
    );
  }
}