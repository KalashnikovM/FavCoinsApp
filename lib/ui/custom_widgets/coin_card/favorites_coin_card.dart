import 'package:crypto_tracker/data/currency_repository/favorites_repository/favorites_repository.dart';
import 'package:crypto_tracker/models/main_coin_model.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../app_colors.dart';
import '../../../router/router.dart';
import '../../../router/router.gr.dart';

class FavoritesCoinCard extends StatelessWidget {
  const FavoritesCoinCard(
      {super.key,
      required this.model,
      required this.index,
      required this.screenWidth});

  final int index;
  final MainCoinModel model;
  final double screenWidth;

  Map<String, dynamic> _parseData() {
    var userData = di<FavoritesRepository>().favUserDataList;
    debugPrint(userData.toString());
    Map<String, dynamic> data = {};
    double transactionCount = 0;
    double avgPurchasePrice = 0;
    double totalPayed = 0;
    double totalCoinValue = 0;
    double currentPriceOfAssets = 0;
    double totalPriceChange = 0;
    double currentPrice = double.parse(model.coinQuote?.price ?? '');

    for (var item in userData) {
      if (item.id == model.id) {
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
    if (transactionCount > 0) {
      avgPurchasePrice = avgPurchasePrice / transactionCount;
    } else {
      avgPurchasePrice = 0;
    }
    double percentageChange = 0;
    if (avgPurchasePrice > 0) {
      percentageChange = ((currentPrice - avgPurchasePrice) / avgPurchasePrice) * 100;
    }

    currentPriceOfAssets = totalCoinValue * currentPrice;
    totalPriceChange = currentPriceOfAssets - totalPayed;
    data['avgPurchasePrice'] = avgPurchasePrice;
    data['percentageChange'] = percentageChange;
    data['totalPayed'] = totalPayed;
    data['totalCoinValue'] = totalCoinValue;
    data['currentPriceOfAssets'] = currentPriceOfAssets;
    data['totalPriceChange'] = totalPriceChange;
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

  double width(screenWidth, percentageChange) {
    double width = 0;
    double res = (screenWidth / 100) * percentageChange.abs();

    screenWidth <= res
        ? width = screenWidth - 24
        : width = res;
    return width;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = _parseData();
    double percentageChange = data['percentageChange'];
    double totalCoinValue = data['totalCoinValue'];
    double currentPriceOfAssets = data['currentPriceOfAssets'];
    double totalPriceChange = data['totalPriceChange'];

    return GestureDetector(
      onTap: () =>
        di<AppRouter>().push(
      CoinPage(model: model),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: model.coinDataModel?.symbol ?? 'N/A',
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                        children: const [
                          TextSpan(
                            text: "/USD",
                            style: TextStyle(
                              color: AppColors.labelStyleGrey,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      model.coinDataModel != null
                          ? (model.coinDataModel?.name != null &&
                                  model.coinDataModel!.name!.length > 15
                              ? '${model.coinDataModel?.name?.substring(0, 15)}...'
                              : model.coinDataModel?.name ?? 'N/A')
                          : 'N/A',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          color: AppColors.whiteColor,
                          size: 18,
                        ),
                        Text(
                          '  $totalCoinValue ${model.coinDataModel?.symbol}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${model.coinQuote?.price ?? "N/A"} USD",
                      style: const TextStyle(
                        fontSize: 18,
                        color:AppColors.whiteColor,
                      ),
                    ),
                    pnlTextWidget(percentageChange, totalPriceChange),
                    Text(
                      '  $currentPriceOfAssets USD',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.whiteColor,
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
                  height: 84,
                  width: width(screenWidth, percentageChange),
                  child: ColoredBox(
                    color: percentageChange.isNegative
                        ? AppColors.mainRed.withOpacity(0.15)
                        : AppColors.mainGreen.withOpacity(0.15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  pnlTextWidget(percentageChange, totalPriceChange) {
    bool isNegative = percentageChange.isNegative;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              " ${convert(percentageChange)} %",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isNegative
                    ? AppColors.mainRed
                    : AppColors.mainGreen,
              ),
            ),
            Text(
              " ${convert(totalPriceChange)} USD",
              style: TextStyle(
                color: isNegative
                    ? AppColors.mainRed
                    : AppColors.mainGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
