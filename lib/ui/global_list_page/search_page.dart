import 'package:crypto_tracker/ui/custom_widgets/coin_card/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../../data/currency_repository/global_repository/global_repository.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  static const Color color = Color(0xFF9b5bf3);
  late TextEditingController _searchController;
  bool searching = false;

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



  Future<void> _search(String query) async {
    setState(() {
      searching = true;
    });

    try {
      GlobalListRepository repo = di<GlobalListRepository>(); // Assuming di is a dependency injection method
      await repo.searchByPartialNameAndSymbol(query);
    } finally {
      setState(() {
        searching = false;
      });
    }
  }






  @override
  Widget build(BuildContext context) {
    debugPrint('build SearchPage');

    GlobalListRepository repo = di<GlobalListRepository>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.93,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          //              color: Colors.purple,
          //             width: 0.5,
          //           ),
          color: const Color(0xFF000000),
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
                      await _search(value);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  filled: true,
                  fillColor: Colors.white12,
                  labelText: "  Enter coin symbol or name.",
                   labelStyle: const TextStyle(
                     color: Color(0xFFcecece),
                   ),
                  suffix: searching
                  ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  )
                    : null,
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

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: repo.foundElementsList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return CoinCard(
                    model: repo.foundElementsList[index],
                    index: index,);
                  },
              ),
            ),



          ],
        ),
      ),
    );
  }
}
