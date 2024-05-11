import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../../models/main_coin_model.dart';
import '../../router/router.dart';
import '../../router/router.gr.dart';




@RoutePage(name: 'CoinPage')

class CoinPage extends StatelessWidget with WatchItMixin{
  const CoinPage({super.key, required this.model, required this.image});

  final MainCoinModel model;
  final Image image;



  @override
  Widget build(BuildContext context) {





    return  Scaffold(
      appBar: AppBar(
        title: Text('id: ${model.id}'),
      ),
         body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${model.coinDataModel.symbol}', style: TextStyle(fontSize: 24),),
                        Text('${model.coinDataModel.name}', style: TextStyle(fontSize: 16),),
                        Text('Category: ${model.coinDataModel.category}'),
                        Text('Price: ${model.coinQuote.price.toStringAsFixed(2)} USD'),
                      ],
                    ),
                    const Expanded(
                      child: SizedBox(),),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                          height: 64,

                          child: image),
                    ),

                  ],
                ),




                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text('${model.coinDataModel.description}'),
                ),
                Text('MarketCap: ${model.coinQuote.marketCap}'),
                Text('Volume24h: ${model.coinQuote.volume24h}'),
                Text('Updated: ${model.coinQuote.lastUpdated.toIso8601String()}'),
                priceWidget("PercentChange1h", model.coinQuote.percentChange1h),
                priceWidget("PercentChange24h", model.coinQuote.percentChange24h),
                priceWidget("PercentChange7d", model.coinQuote.percentChange7d),
                priceWidget("PercentChange30d", model.coinQuote.percentChange30d),
                priceWidget("PercentChange60d", model.coinQuote.percentChange60d),
                priceWidget("PercentChange90d", model.coinQuote.percentChange90d),
                priceWidget("VolumeChange24h", model.coinQuote.volumeChange24h),

                Text('MarketCapDominance: ${model.coinQuote.marketCapDominance}'),
                Text('Fully diluted market Cap: ${model.coinQuote.fullyDilutedMarketCap} USD'),




              ]),
        ),

      ),
    );
  }
}


priceWidget (String text, double data) {
  return Row(
    children: [
      Text(text, ),
      const Expanded(child: SizedBox(),),

      Text("${data.toStringAsFixed(2)}%",
        style: TextStyle(
          color: data.isNegative
              ? Colors.red
              :Colors.green,


        ),),
      data.isNegative
      ? const Icon(Icons.arrow_drop_down, color: Colors.red,)
      : const Icon(Icons.arrow_drop_up, color: Colors.green,),
    ],
  );






}