import 'package:auto_route/annotations.dart';
import 'package:crypto_tracker/data/user_repository/user_repository.dart';
import 'package:crypto_tracker/ui/custom_widgets/coin_card/favorites_coin_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../../app_colors.dart';
import '../../data/currency_repository/favorites_repository/favorites_repository.dart';
import '../../router/router.dart';
import '../profile_screen/profile_screen.dart';
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
              title:  Text('Favorites ${repo.favoritesList.length}'),
              leading:  IconButton(
                  onPressed: () {



                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) => const ProfileScreen(),
                    );


                  },
                  icon: const Icon(Icons.account_circle_outlined)),
              actions: [



                IconButton(
                    onPressed: () => showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoActionSheet(
                            cancelButton: CupertinoActionSheetAction(
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                              ),
                            ),
                              actions: <CupertinoActionSheetAction>[
                              CupertinoActionSheetAction(
                                isDestructiveAction: true,
                                onPressed: () async {
                                  di<UserRepository>().logoutUser();
                                  di<AppRouter>().maybePop();

                                  // di<AppRouter>().replace(const SplashRoute());
                                },
                                child: const Text(
                                  'Logout',
                                ),
                              ),
                            ],
                          ),
                        ),
                    icon: const Icon(
                      Icons.logout,
                      color: AppColors.mainRed,
                    )),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: repo.favoritesList.length,
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
        : Scaffold(
          body: Center(
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
                      color: AppColors.mainGreen,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.login,
                      size: 24,
                      color: AppColors.mainGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
