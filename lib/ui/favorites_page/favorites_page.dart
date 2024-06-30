import 'package:auto_route/annotations.dart';
import 'package:crypto_tracker/data/user_repository/user_repository.dart';
import 'package:crypto_tracker/ui/custom_widgets/coin_card/favorites_coin_card.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../../data/currency_repository/favorites_repository/favorites_repository.dart';
import '../sign_screen/sign_screen.dart';






@RoutePage(name: 'FavoritesPage')
class FavoritesPage extends StatelessWidget with WatchItMixin {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('build FavoritesPage');
    FavoritesRepository repo = watchIt<FavoritesRepository>();
    UserRepository userRepository = watchIt<UserRepository>();

    return userRepository.status == UserStatus.login
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                  'Favorites ${userRepository.favList.length}'),
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
                      itemCount:repo.favoritesList.length,
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

}
