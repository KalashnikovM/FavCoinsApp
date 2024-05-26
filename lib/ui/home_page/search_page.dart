import 'package:crypto_tracker/data/currency_repository/currency_repository.dart';
import 'package:crypto_tracker/ui/custom_widgets/coin_card/coin_card.dart';
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
            const SizedBox(height: 8,),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                      // border: Border.all(
                      //              color: Colors.purple,
                      //             width: 0.5,
                      //           ),
                    ),
                width: 60,
                height: 8,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                style: const TextStyle(
                  fontSize: 20
                ),
                controller: _searchController,
                onChanged: (value) async {

                  if(value.length > 1) {


                 bool res = await repo.getFunc(_searchController.text);
                 res
                     ? setState(() {

                 })
                      : null;
                }},
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  filled: true,
                  fillColor: Colors.white12,
                  labelText: "  Enter coin symbol.",
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
                  const Expanded(
                     flex: 3,
                     child: SizedBox(),),

                  const Center(
                    child: Text("Search history"),
                  ),
                  const Expanded(
                    flex: 2,
                    child: SizedBox(),),


                  IconButton(
                    onPressed: () {


                      setState(() {


                        repo.resList;


                      });

                    },
                    icon: const Icon(Icons.clear),
                    // child:  const Text("Clear search history"),
                  ),
                ],
              ),
            ),

            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: repo.foundElementsList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return CoinCard(
                  model: repo.foundElementsList[index],
                  index: index,);
                },
            ),



          ],
        ),
      ),
    );
  }
}
