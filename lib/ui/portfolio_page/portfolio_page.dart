import 'package:auto_route/annotations.dart';

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../data/currency_repository/currency_repository.dart';
import '../../models/main_coin_model.dart';
import '../../router/router.dart';
import '../../router/router.gr.dart';






@RoutePage(name: 'PortfolioPage')

class PortfolioPage extends StatelessWidget with WatchItMixin{
  const PortfolioPage({super.key});


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
        leading: GestureDetector(
            onTap: () => repo.startTestStream,



            child: const Icon(Icons.circle_outlined)),
        title: const Text("Test list stream"),
      ),
      body: const SafeArea(
          child: Center(child: Text("test"),))







          // ListView.builder(
          //   padding: const EdgeInsets.symmetric(horizontal: 8),
          //   itemCount: repo.testCoinModelList.length,
          //   shrinkWrap: true,
          //   itemBuilder: (BuildContext context, int index) {
          //     MainCoinModel item = repo.testCoinModelList[index];
          //     Image image = Image.network(
          //       item.coinDataModel.logo.toString(),
          //     );
          //     return GestureDetector(
          //       onTap: () =>
          //           di<AppRouter>().push(CoinPage(model: item, image: image)),
          //       child: Container(
          //         margin: const EdgeInsets.symmetric(vertical: 4),
          //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          //         decoration: const BoxDecoration(
          //           // border: Border.all(
          //           //   // color: Colors.purple,
          //           //   width: 0.5,
          //           // ),
          //           color: Color(0xFF3e3e3e),
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(8),
          //           ),
          //         ),
          //         child: Column(
          //           children: [
          //             Row(
          //               children: [
          //                 SizedBox(width: 36, child: image),
          //                 const Expanded(
          //                   flex: 1,
          //                   child: SizedBox(),
          //                 ),
          //                 Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text(item.coinDataModel.symbol.toString(),
          //                       style: const TextStyle(
          //                           color: Colors.white,
          //                           fontWeight: FontWeight.w400,
          //                           fontSize: 17),),
          //                     Text(item.coinDataModel.name.toString(),
          //                       style: const TextStyle(
          //                           color: Colors.white,
          //                           fontWeight: FontWeight.w500),),
          //
          //                   ],
          //                 ),
          //                 const Expanded(
          //                   flex: 10,
          //                   child: SizedBox(),
          //                 ),
          //                 Text(
          //                   countZerosAfterDecimal(item.coinQuote.price),
          //                   style: const TextStyle(
          //                     fontSize: 18,
          //                     color: Colors.white,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // )),

    );
  }
}
