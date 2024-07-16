import 'package:crypto_tracker/models/main_coin_model.dart';
import 'package:crypto_tracker/router/router.dart';
import 'package:crypto_tracker/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../app_colors.dart';

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
          color: AppColors.blackColor,
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
                Text(
                  model.coinDataModel?.symbol ?? 'N/A',
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),),


                Text(
                  model.coinDataModel != null
                      ? (model.coinDataModel?.name != null && model.coinDataModel!.name!.length > 15
                      ? '${model.coinDataModel?.name?.substring(0, 15)}...'
                      : model.coinDataModel?.name ?? 'N/A')
                      : 'N/A',

                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.whiteColor,
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
                    color: AppColors.whiteColor,
                  ),
                ),
                Text(
                  "1h: ${model.coinQuote?.percentChange1h ?? 'N/A'} %",
                  style: TextStyle(
                    color: model.coinQuote?.percentChange1h.startsWith("-") ?? false
                        ? AppColors.mainRed
                        : AppColors.mainGreen,
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