import 'package:auto_route/annotations.dart';
import 'package:crypto_tracker/data/favorites_repository.dart';
import 'package:crypto_tracker/data/user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../custom_widgets/coin_card/coin_card.dart';
import '../custom_widgets/custom_refresh_indicator/custom_refresh_indicator.dart';
import '../sign_screen/sign_screen.dart';

@RoutePage(name: 'FavoritesPage')
class FavoritesPage extends StatelessWidget with WatchItMixin {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    FavoritesRepository repo = watchIt<FavoritesRepository>();
    UserStatus status = watchIt<UserRepository>().status;


    return CustomRefreshIndicator(
      // color: Colors.transparent,
      onRefresh: () async {
        di<FavoritesRepository>().updateFavoritesList();
      },
      child: status == UserStatus.login
          ? Scaffold(
        appBar: AppBar(
          title: Text(' Total: ${repo.idsList.length}    Favorites '),
          actions: [


            IconButton(
                onPressed: () {
                  di<UserRepository>().logoutUser();
                },                icon: const Icon(Icons.logout,  color: Color(0xFFFA2D48),)),

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
            child: const Text("Sign", style: TextStyle(color: Colors.white),),
          ),
        ),),
    );
  }


}
