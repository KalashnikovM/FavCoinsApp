import 'package:crypto_tracker/data/currency_repository/currency_repository.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/main_coin_model.dart';
import '../../router/router.dart';
import '../../router/router.gr.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {


  late TextEditingController _searchController;

  price (String text, double data) {
    return Text("$text ${data.toStringAsFixed(2)}%",
      style: TextStyle(
        color: data.isNegative
            ? Colors.red
            : Colors.green,
      ),);
  }

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
    return "${number.toStringAsFixed(zeroCount)} \$";
  }


  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }




  @override
  Widget build(BuildContext context) {

    CurrencyRepository repo = di<CurrencyRepository>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.93,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF2e2e2e),
        ),

        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                style: const TextStyle(
                  fontSize: 20
                ),
                controller: _searchController,
                onChanged: (value) async {
                 bool res = await repo.searchCoin(_searchController.text);
                 res
                     ? setState(() {

                 })
                      : null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  filled: true,
                  fillColor: Colors.white12,
                  labelText: "  Enter coin name",
                   labelStyle: const TextStyle(
                     color: Color(0xFFcecece),
                   ),

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Center(
                    child: Text("Search page"),
                  ),
                  const Expanded(child: SizedBox(),),


                  SizedBox(
                    height: 24,
                    child: ElevatedButton(
                      onPressed: () {


                        setState(() {


                          repo.resList;


                        });

                      },
                      child:  const Text("Clear search history"),),
                  ),
                ],
              ),
            ),

            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: repo.foundElementsList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                MainCoinModel item = repo.foundElementsList[index];
                Image image = Image.memory(item.coinDataModel.logo);
                return GestureDetector(
                  onTap: () =>
                      di<AppRouter>().push(CoinPage(model: item,)),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: const BoxDecoration(
                      // border: Border.all(
                      //   // color: Colors.purple,
                      //   width: 0.5,
                      // ),
                      color: Color(0xFF2e2e2e),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text("${index+1}", style: const TextStyle(
                            fontSize: 20,
                          ),),
                        ),
                        SizedBox(width: 36, child: image),
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(text: "${item.coinDataModel.symbol}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17),
                                children: const [
                                  TextSpan(text: "/USD",
                                    style: TextStyle(
                                        color: Colors.white54,
                                        //   fontWeight: FontWeight.w300,
                                        fontSize: 15),
                                  ),],

                              ),),


                            Text(item.coinDataModel.name.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),),

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
                              countZerosAfterDecimal(item.coinQuote.price),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            price("1h change:", item.coinQuote.percentChange1h),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),



          ],
        ),
      ),
    );
  }
}
