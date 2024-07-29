import 'package:auto_route/annotations.dart';
import 'package:crypto_tracker/data/currency_repository/favorites_repository/favorites_repository.dart';
import 'package:crypto_tracker/data/user_repository/user_repository.dart';
import 'package:crypto_tracker/ui/sign_screen/sign_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watch_it/watch_it.dart';
import '../../app_colors.dart';
import '../../models/favorite_model.dart';
import '../../models/main_coin_model.dart';
import '../custom_widgets/add_favorite_coin/add_favorite_coin.dart';

@RoutePage(name: 'CoinPage')
class CoinPage extends StatelessWidget with WatchItMixin {
  const CoinPage({super.key, required this.model});

  final MainCoinModel model;


   bool isFavorites(String id) {
     bool res = false;
     res = di<FavoritesRepository>().isFavorites(model.id);

     return res;
   }



  @override
  Widget build(BuildContext context) {
    FavoritesRepository repo = watchIt<FavoritesRepository>();

    DateTime? utcDateTime;
    DateTime? dateTime;
    String updatedDate = '';

    if (model.coinQuote != null) {
      utcDateTime =
          DateTime.parse(model.coinQuote!.lastUpdated.toIso8601String());
      dateTime = utcDateTime.toLocal();
      updatedDate = DateFormat('HH:mm dd MMMM yyyy').format(dateTime);
    }

    var logo = model.coinDataModel?.logo;
    bool isFavorited = repo.isFavorites(model.id);
    debugPrint(model.coinQuote?.percentChange1h);
    return Scaffold(
      appBar: AppBar(
        title: Text(model.coinDataModel?.name ?? ""),
        titleTextStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.whiteColor,
        ),

        actions: [
          IconButton(
              onPressed: () {

                isFavorited
                ? repo.removeFromFavorites(model.id)
                : showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return di<UserRepository>().status != UserStatus.login
                      ? const SignScreen()
                      : AddFavoriteCoin(
                    id: model.id,
                    price: model.coinQuote?.price ?? "",

                  );

                  },
                );
              },
            icon: Icon(
              isFavorited
              ? Icons.star
              : Icons.star_border,
         color: AppColors.mainRed,),),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.coinDataModel?.symbol ?? 'N/A',
                        style: const TextStyle(
                            fontSize: 24, color: AppColors.whiteColor),
                      ),
                      Text(
                        model.coinDataModel?.name ?? 'N/A',
                        style: const TextStyle(
                            fontSize: 16, color: AppColors.whiteColor),
                      ),
                      Text(
                          'Category: ${model.coinDataModel?.category ?? 'N/A'}'),
                    ],
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: 46,
                      child: logo != null
                          ? Image.memory(logo)
                          : const CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
              Text(
                'Price: ${model.coinQuote?.price ?? 'N/A'} USD',
                style: const TextStyle(
                  fontSize: 20,
                  color:AppColors.whiteColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  model.coinDataModel?.description ?? 'N/A',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (model.coinQuote != null) ...[
                priceWidget(
                    "Percent change 1h", model.coinQuote?.percentChange1h ?? ''),
                const SizedBox(height: 4),
                priceWidget(
                    "Percent change 24h", model.coinQuote?.percentChange24h ?? ''),
                const SizedBox(height: 4),
                priceWidget(
                    "Percent change 7d", model.coinQuote?.percentChange7d  ?? ''),
                const SizedBox(height: 4),
                priceWidget(
                    "Percent change 30d", model.coinQuote?.percentChange30d ?? ''),
                const SizedBox(height: 4),
                priceWidget(
                    "Percent change 60d", model.coinQuote?.percentChange60d  ?? ''),
                const SizedBox(height: 4),
                priceWidget(
                    "Percent change 90d", model.coinQuote?.percentChange90d  ?? ''),
                const SizedBox(height: 4),
                priceWidget(
                    "Volume change 24h", model.coinQuote?.volumeChange24h  ?? ''),
                const SizedBox(height: 4),
                Text(
                    'Market Cap dominance: ${model.coinQuote?.marketCapDominance} %'),
                const SizedBox(height: 4),
                Text(
                    'Fully diluted market Cap: ${model.coinQuote?.fullyDilutedMarketCap} ${model.coinDataModel?.symbol}'),
                const SizedBox(height: 4),

                Text('Last update: $updatedDate'),
                const SizedBox(height: 4),

              ]
            ],
          ),
        ),
      ),
    );
  }
}

priceWidget(String text, String data) {
  return Row(
    children: [
      Text(
        text,
      ),
      const Expanded(
        child: SizedBox(),
      ),
      Text(
        "$data%",
        style: TextStyle(
          fontSize: 16,
          color: data.startsWith("-") ? Colors.red : Colors.green,
        ),
      ),
      data.startsWith("-")
          ? const Icon(
              Icons.arrow_drop_down,
              color: AppColors.mainRed,
              size: 32,
            )
          : const Icon(
              Icons.arrow_drop_up,
              color: AppColors.mainGreen,
              size: 32,
            ),
    ],
  );
}
