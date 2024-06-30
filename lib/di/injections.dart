import 'package:crypto_tracker/data/currency_repository/top_repository/top_repository.dart';
import 'package:crypto_tracker/data/user_repository/user_repository.dart';
import 'package:crypto_tracker/di/injections.config.dart';
import 'package:crypto_tracker/router/router.dart';
import 'package:injectable/injectable.dart';
import 'package:watch_it/watch_it.dart';
import '../data/currency_repository/favorites_repository/favorites_repository.dart';
import '../data/currency_repository/global_repository/global_repository.dart';
import '../services/appwrite_service.dart';
import '../services/messaging_service.dart';

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() {
  di.init();
  di.registerSingleton<AppRouter>(AppRouter());
  di.registerSingleton<ApiClient>(ApiClient());
  di.registerSingleton<UserRepository>(UserRepository());
  di.registerSingleton<FavoritesRepository>(FavoritesRepository());
  di.registerSingleton<GlobalListRepository>(GlobalListRepository());
  di.registerSingleton<Top100Repository>(Top100Repository());
  di.registerSingleton<LocalNotification>(LocalNotification());




}