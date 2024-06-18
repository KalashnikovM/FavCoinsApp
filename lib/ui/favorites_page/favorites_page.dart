import 'package:auto_route/annotations.dart';
import 'package:crypto_tracker/data/currency_repository/currency_repository.dart';
import 'package:crypto_tracker/data/user_repository/user_repository.dart';
import 'package:crypto_tracker/ui/custom_widgets/coin_card/favorites_coin_card.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../sign_screen/sign_screen.dart';
import 'package:fl_chart/fl_chart.dart';

@RoutePage(name: 'FavoritesPage')
class FavoritesPage extends StatelessWidget with WatchItMixin {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    CurrencyRepository repo = watchIt<CurrencyRepository>();
    UserRepository userRepository = watchIt<UserRepository>();

    return userRepository.status == UserStatus.login
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                  ' Total: ${userRepository.favList.length}    Favorites '),
              actions: [
                IconButton(
                    onPressed: () {
                      di<UserRepository>().logoutUser();
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Color(0xFFFA2D48),
                    )),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // const Padding(
                  //   padding: EdgeInsets.all(8.0),
                  //   child: BarChartSample4(),
                  // ),

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: userRepository.favList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return FavoritesCoinCard(
                          model: repo.favoritesList[index],
                          index: index,
                          screenWidth: MediaQuery.of(context).size.width,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        : ColoredBox(
            color: Colors.black,
            child: Center(
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) => const SignScreen(),
                  );
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign",
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF76CD26),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.login,
                        size: 24,
                        color: Color(0xFF76CD26),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    Color dark = Colors.black;
    Color normal = const Color(0xFFFA2D48);
    Color light = Colors.white;

    return [
      BarChartGroupData(
        x: 0,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 17000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 2000000000, dark),
              BarChartRodStackItem(2000000000, 12000000000, normal),
              BarChartRodStackItem(12000000000, 17000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 24000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 13000000000, dark),
              BarChartRodStackItem(13000000000, 14000000000, normal),
              BarChartRodStackItem(14000000000, 24000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 23000000000.5,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000.5, dark),
              BarChartRodStackItem(6000000000.5, 18000000000, normal),
              BarChartRodStackItem(18000000000, 23000000000.5, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 29000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 9000000000, dark),
              BarChartRodStackItem(9000000000, 15000000000, normal),
              BarChartRodStackItem(15000000000, 29000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 32000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 2000000000.5, dark),
              BarChartRodStackItem(2000000000.5, 17000000000.5, normal),
              BarChartRodStackItem(17000000000.5, 32000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 31000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 11000000000, dark),
              BarChartRodStackItem(11000000000, 18000000000, normal),
              BarChartRodStackItem(18000000000, 31000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 35000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 14000000000, dark),
              BarChartRodStackItem(14000000000, 27000000000, normal),
              BarChartRodStackItem(27000000000, 35000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 31000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 8000000000, dark),
              BarChartRodStackItem(8000000000, 24000000000, normal),
              BarChartRodStackItem(24000000000, 31000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 15000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000.5, dark),
              BarChartRodStackItem(6000000000.5, 12000000000.5, normal),
              BarChartRodStackItem(12000000000.5, 15000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 17000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 9000000000, dark),
              BarChartRodStackItem(9000000000, 15000000000, normal),
              BarChartRodStackItem(15000000000, 17000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 34000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000, dark),
              BarChartRodStackItem(6000000000, 23000000000, normal),
              BarChartRodStackItem(23000000000, 34000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 32000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 7000000000, dark),
              BarChartRodStackItem(7000000000, 24000000000, normal),
              BarChartRodStackItem(24000000000, 32000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 14000000000.5,
            rodStackItems: [
              BarChartRodStackItem(0, 1000000000.5, dark),
              BarChartRodStackItem(1000000000.5, 12000000000, normal),
              BarChartRodStackItem(12000000000, 14000000000.5, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 20000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 4000000000, dark),
              BarChartRodStackItem(4000000000, 15000000000, normal),
              BarChartRodStackItem(15000000000, 20000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 24000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 4000000000, dark),
              BarChartRodStackItem(4000000000, 15000000000, normal),
              BarChartRodStackItem(15000000000, 24000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 14000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 1000000000.5, dark),
              BarChartRodStackItem(1000000000.5, 12000000000, normal),
              BarChartRodStackItem(12000000000, 14000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 27000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 7000000000, dark),
              BarChartRodStackItem(7000000000, 25000000000, normal),
              BarChartRodStackItem(25000000000, 27000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 29000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000, dark),
              BarChartRodStackItem(6000000000, 23000000000, normal),
              BarChartRodStackItem(23000000000, 29000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 16000000000.5,
            rodStackItems: [
              BarChartRodStackItem(0, 9000000000, dark),
              BarChartRodStackItem(9000000000, 15000000000, normal),
              BarChartRodStackItem(15000000000, 16000000000.5, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: 15000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 7000000000, dark),
              BarChartRodStackItem(7000000000, 12000000000.5, normal),
              BarChartRodStackItem(12000000000.5, 15000000000, light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
    ];
  }
}
//
//   _charts() {
//     List<LineChartBarData> widgets = [];
//     Map<String, dynamic> items = di<UserRepository>().favoritesData;
//     double allValue = 0;
//     items.forEach((key, value) {
//       allValue += double.parse(value);
//     });
//
//     items.forEach((key, value) {
//       widgets.add(LineChartBarData(
//
//           //
//           // title: key,
//           //   value: (double.parse(value)/allValue) * 100,
//           color: Colors.redAccent));
//       allValue += double.parse(value);
//     });
//     return widgets;
//   }
// }

//
// child:  LineChart(
// LineChartData(
// // gridData: FlGridData(
// //   show: true,
// //   drawVerticalLine: true,
// //   getDrawingHorizontalLine: (value) {
// //     return const FlLine(
// //       color: Color(0xffe7e8ec),
// //       strokeWidth: 1,
// //     );
// //   },
// //   getDrawingVerticalLine: (value) {
// //     return const FlLine(
// //       color: Color(0xffe7e8ec),
// //       strokeWidth: 1,
// //     );
// //   },
// // ),
// titlesData: const FlTitlesData(
// show: true,
// rightTitles: AxisTitles(
// sideTitles: SideTitles(showTitles: false),
// ),
// topTitles: AxisTitles(
// sideTitles: SideTitles(showTitles: false),
// ),
// leftTitles: AxisTitles(
// sideTitles: SideTitles(showTitles: false),
// ),
// bottomTitles: AxisTitles(
// sideTitles: SideTitles(showTitles: false),
// ),),
// // borderData: FlBorderData(
// //   show: true,
// //   border: Border.all(
// //     color: const Color(0xffe7e8ec),
// //     width: 1,
// //   ),
// // ),
// // minX: 0,
// // maxX: 7,
// // minY: 0,
// // maxY: 6,
// lineBarsData: [
// LineChartBarData(
// spots: [
// const FlSpot(0, 3),
// const FlSpot(1, 1),
// const FlSpot(2, 4),
// const FlSpot(3, 3.5),
// const FlSpot(4, 2),
// const FlSpot(5, 5),
// const FlSpot(6, 4),
// ],
// isCurved: true,
// color: Colors.redAccent,
// barWidth: 2,
// isStrokeCapRound: false,
// // belowBarData: BarAreaData(
// //   show: true,
// //   color: Colors.blue.withOpacity(0.3),
// // ),
// ),
// ],
// ),
// ),
