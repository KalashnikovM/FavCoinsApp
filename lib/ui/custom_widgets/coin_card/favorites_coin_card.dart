import 'package:crypto_tracker/data/user_repository/user_repository.dart';
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



  _width() {
    var userData = di<UserRepository>().favList;


    double changeBlock = screenWidth * model.;




  }




  @override
  Widget build(BuildContext context) {
    // var logo = model.coinDataModel?.logo;

    return GestureDetector(
      onTap: () => di<AppRouter>().push(
        CoinPage(model: model),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
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
                      "PnL: ${model.coinQuote?.percentChange1h ?? 'N/A'} %",
                      style: TextStyle(
                        color: model.coinQuote?.percentChange1h.startsWith("-") ?? false
                            ?  const Color(0xFFFA2D48)
                            : const Color(0xFF76CD26),
                      ),
                    ),
                  ],
                ),
              ],
            ),

             Row(

              children: [
                SizedBox(
                  width: 15,
                  height: 50,
                  child: ColoredBox(color: Colors.red.withOpacity(0.3),),
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