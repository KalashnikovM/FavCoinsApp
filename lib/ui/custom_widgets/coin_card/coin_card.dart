import 'package:crypto_tracker/models/main_coin_model.dart';
import 'package:crypto_tracker/router/router.dart';
import 'package:crypto_tracker/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class CoinCard extends StatelessWidget {
  const CoinCard({super.key, required this.model, required this.index});

  final int index;
  final MainCoinModel model;

  @override
  Widget build(BuildContext context) {
    var logo = model.coinDataModel?.logo;

    return GestureDetector(
      onTap: () => di<AppRouter>().push(
        CoinPage(model: model),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: const BoxDecoration(
          color: Color(0xFF000000),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(
                "${index + 1}",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              width: 36,
              child: logo != null
                  ? Image.memory(logo)
                  : const CircularProgressIndicator(),
            ),
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
                  "1h: ${model.coinQuote?.percentChange1h ?? 'N/A'} %",
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
      ),
    );
  }
}