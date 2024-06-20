import 'package:crypto_tracker/data/user_repository/user_repository.dart';
import 'package:crypto_tracker/models/favorite_model.dart';
import 'package:crypto_tracker/models/main_coin_model.dart';
import 'package:crypto_tracker/router/router.dart';
import 'package:crypto_tracker/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class FavoritesCoinCard extends StatelessWidget {
  const FavoritesCoinCard({super.key, required this.model, required this.index, required this.screenWidth});

  final int index;
  final MainCoinModel model;
  final double screenWidth;





  Map<String, dynamic> _parseData() {
    var userData = di<UserRepository>().favList;
    debugPrint(userData.toString());

    Map<String, dynamic> data = {};

    double transactionCount = 0;
    double avgPurchasePrice = 0;
    double totalPayed = 0;
    double totalCoinValue = 0;
    double currentPrice = double.parse(model.coinQuote?.price ?? '');

    for (var item in userData) {

      if(item.id == model.id){

      item.transactions.forEach((p, v) {
        transactionCount += 1;
        double price = double.parse(p);
        double value = double.parse(v);
        totalPayed += price * value;
        totalCoinValue += value;
        avgPurchasePrice += price;
      });
     }
    }
    avgPurchasePrice = avgPurchasePrice/transactionCount;
    double percentageChange = ((currentPrice - avgPurchasePrice) / avgPurchasePrice) * 100;

    data['avgPurchasePrice'] = avgPurchasePrice;
    data['percentageChange'] = percentageChange;
    data['totalPayed'] = totalPayed;
    data['totalCoinValue'] = totalCoinValue;







    debugPrint("totalPayed");

    debugPrint(totalPayed.toString());

    debugPrint("totalCoinValue");

    debugPrint(totalCoinValue.toString());

    debugPrint("transactionCount");

    debugPrint(transactionCount.toString());

    debugPrint("avgPurchasePrice");

    debugPrint(avgPurchasePrice.toString());
    debugPrint("percentageChange");

    debugPrint(percentageChange.toString());

    return data;
  }

  String convert(double number) {
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
    return number.toStringAsFixed(zeroCount);
  }


  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> data = _parseData();
    double percentageChange = data['percentageChange'];
    double totalCoinValue = data['totalCoinValue'];
    double avgPurchasePrice = data['avgPurchasePrice'];


    return GestureDetector(
      onTap: () => _parseData(),
        //   di<AppRouter>().push(
        // CoinPage(model: model),
      //),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Stack(
          children: [





            Row(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(right: 12.0),
                //   child: Text(
                //     "${index + 1}",
                //     style: const TextStyle(
                //       fontSize: 18,
                //     ),
                //   ),
                // ),

                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: model.coinDataModel?.symbol ?? 'N/A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                        children: const [
                          TextSpan(
                            text: "/USD",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      model.coinDataModel != null
                          ? (model.coinDataModel?.name != null && model.coinDataModel!.name!.length > 15
                          ? '${model.coinDataModel?.name?.substring(0, 15)}...'
                          : model.coinDataModel?.name ?? 'N/A')
                          : 'N/A',

                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),




                    Row(
                      children: [
                        const Icon(Icons.account_balance_wallet, color: Colors.white38,size: 18,),
                        Text(
                          '  $totalCoinValue ${model.coinDataModel?.symbol}',

                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),





                  ],
                ),
                const Expanded(
                  flex: 10,
                  child: SizedBox(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${model.coinQuote?.price ?? "N/A"}\$",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "PnL: ${convert(percentageChange)} %",
                      style: TextStyle(
                        color: model.coinQuote?.percentChange1h.startsWith("-") ?? false
                            ?  const Color(0xFFFA2D48)
                            : const Color(0xFF76CD26),
                      ),
                    ),




                    Text(
                      '  $avgPurchasePrice \$',

                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),

                  ],
                ),
              ],
            ),

             Row(
              children: [
                SizedBox(
                  height: 64,
                  width: percentageChange.abs(),
                  child: ColoredBox(color: percentageChange.isNegative
                      ?  const Color(0xFFFA2D48).withOpacity(0.3)
                      : const Color(0xFF76CD26).withOpacity(0.3),

                 ),
                ),
                const Expanded(child: SizedBox(),),




              ],
            ),



          ],
        ),
      ),
    );
  }
}