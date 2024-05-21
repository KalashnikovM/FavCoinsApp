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
        leading: GestureDetector(
            onTap: () => repo.testStream ? null : repo.startTestStream(),
            child: Icon(repo.testStream ? Icons.circle : Icons.circle_outlined)),
        title: Text("Test list stream. ${repo.testElementsList.length}"),
      ),
      body: RefreshIndicator(
        color: Colors.purple,
        onRefresh: () async {
          await repo.getTestList();
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
                      itemCount: repo.testElementsList.length,
                       shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index)  {
                        MainCoinModel item = repo.testElementsList[index];
                        Image image = Image.memory(item.coinDataModel.logo);
                         // debugPrint("${index +2 == repo.testElementsList.length+1}\n $index\n ${repo.testElementsList.length}");
                        return
                        //   index+1 == repo.testElementsList.length && repo.mainListPageStatus != CurrencyRepositoryStatus.updating
                        // ?  ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //       backgroundColor: Colors.purple,
                        //       disabledBackgroundColor: Colors.red,
                        //       shape: const CircleBorder(),
                        //       fixedSize: const Size(44,44)
                        //   ),
                        //   onPressed: () => repo.getTestList(),
                        //   child: const Icon(Icons.more, size: 24,),
                        // )
                        //
                        //
                        //
                        //
                        // :
                          GestureDetector(
                          onTap: () =>
                              di<AppRouter>().push(
                                CoinPage(model: item),
                              ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2e2e2e),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0),
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 36, child: image),
                                const Expanded(
                                  flex: 1,
                                  child: SizedBox(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: "${item.coinDataModel
                                            .symbol}",
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
                                      item.coinDataModel.name.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
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
                                      item.coinQuote.price,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text("1h change: ${item.coinQuote.percentChange1h}",
                                      style: TextStyle(
                                        color: item.coinQuote.percentChange1h.startsWith("-")
                                            ? Colors.red
                                            : Colors.green,),),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),


                   if(repo.mainListPageStatus == CurrencyRepositoryStatus.updated)
                   TextButton(
                     style: ElevatedButton.styleFrom(
                         foregroundColor:const Color(0xFF9b5bf3),
                      elevation: 0,
                      //   backgroundColor: Colors.purple,
                         disabledBackgroundColor: Colors.red,
                         // shape: const CircleBorder(),
                         // fixedSize: const Size(44,44)
                     ),
                     onPressed: () => repo.getTestList(),
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
