import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watch_it/watch_it.dart';
import '../../models/main_coin_model.dart';

@RoutePage(name: 'CoinPage')
class CoinPage extends StatelessWidget with WatchItMixin {
  const CoinPage({super.key, required this.model});

  final MainCoinModel model;

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Updated: $updatedDate'),
        titleTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        model.coinDataModel?.symbol ?? 'N/A',
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      Text(
                        model.coinDataModel?.name ?? 'N/A',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
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
                      width: 36,
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
                  color: Colors.white,
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
                    "Percent change 1h", model.coinQuote!.percentChange1h),
                const SizedBox(height: 4),
                priceWidget(
                    "Percent change 24h", model.coinQuote!.percentChange24h),
                const SizedBox(height: 4),
                priceWidget(
                    "Percent change 7d", model.coinQuote!.percentChange7d),
                const SizedBox(height: 4),
                priceWidget(
                    "Percent change 30d", model.coinQuote!.percentChange30d),
                const SizedBox(height: 4),
                priceWidget(
                    "Percent change 60d", model.coinQuote!.percentChange60d),
                const SizedBox(height: 4),
                priceWidget(
                    "Percent change 90d", model.coinQuote!.percentChange90d),
                const SizedBox(height: 4),
                priceWidget(
                    "Volume change 24h", model.coinQuote!.volumeChange24h),
                const SizedBox(height: 4),
                Text(
                    'Market Cap dominance: ${model.coinQuote!.marketCapDominance}'),
                const SizedBox(height: 4),
                Text(
                    'Fully diluted market Cap: ${model.coinQuote!.fullyDilutedMarketCap}'),
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
              color: Colors.red,
              size: 32,
            )
          : const Icon(
              Icons.arrow_drop_up,
              color: Colors.green,
              size: 32,
            ),
    ],
  );
}
