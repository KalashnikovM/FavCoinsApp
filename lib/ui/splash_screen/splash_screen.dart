import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../router/router.dart';
import '../../router/router.gr.dart';



@RoutePage(name: 'SplashRoute')
class SplashScreen extends StatelessWidget with WatchItMixin {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Widget build SplashScreen');


    Future<void> navigateAfterAnimation() async {

      await Future.delayed(const Duration(milliseconds: 1100));
      di<AppRouter>().replace(const MainScreenRoute());


    }

    navigateAfterAnimation();

    return const Scaffold(
      body: Center(
        child: AnimationEx(),
      ),
    );
  }
}

class AnimationEx extends StatefulWidget {
  const AnimationEx({super.key});

  @override
  State<AnimationEx> createState() => _AnimationExState();
}

class _AnimationExState extends State<AnimationEx> {
  @override
  Widget build(BuildContext context) {

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1, end: 0),
      duration: const Duration(milliseconds: 500),
      builder: (BuildContext context, double value, child) {
       // debugPrint(value.toString());
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: const Center(
        child: CircularProgressIndicator(),


        // Container(
        //   decoration: const BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage('assets/img/X - 3.png'),
        //       fit: BoxFit.fitHeight,
        //
        //     ),
        //   ),
        // ),
      ),
    );
  }
}