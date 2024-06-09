import 'package:auto_route/annotations.dart';
import 'package:crypto_tracker/data/currency_repository/currency_repository.dart';
import 'package:crypto_tracker/data/user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../custom_widgets/coin_card/coin_card.dart';
import '../sign_screen/sign_screen.dart';

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
        title: Text(' Total: ${userRepository.idsList.length}    Favorites '),
        actions: [


          IconButton(
              onPressed: () {
                di<UserRepository>().logoutUser();
              },
              icon: const Icon(Icons.logout,  color: Color(0xFFFA2D48),)),

        ],
      ),
          body: SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: repo.favoritesList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return CoinCard(
                  model: repo.favoritesList[index],
                  index: index,);
              },
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
              builder: (BuildContext context) =>
              const SignScreen(),
            );



          },
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign",
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFF76CD26),
              ),),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.login,
                size: 24,
                  color: Color(0xFF76CD26),
                ),
              )
            ],
          ),
        ),
      ),);
  }


}
