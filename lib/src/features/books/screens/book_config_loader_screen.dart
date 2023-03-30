import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

// Features
import '../../home/home.dart';
import '../../categories/categories.dart';
import '../../wallets/wallets.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/extensions/extensions.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

final _cacheLoaderFutureProvider = FutureProvider.autoDispose<void>(
  (ref) => Future.wait<void>([
    Future.delayed(3.seconds),
    ref.watch(categoriesMapProvider.future),
    ref.watch(walletsMapProvider.future),
    ref.watch(currenciesMapProvider.future),
  ]),
);

class BookConfigLoaderScreen extends ConsumerWidget {
  const BookConfigLoaderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheLoaderFuture = ref.watch(_cacheLoaderFutureProvider);
    return cacheLoaderFuture.when(
      data: (_) => const HomeScreen(),
      loading: () => const LottieAnimationLoader(),
      error: (error, st) => Scaffold(
        body: ErrorResponseHandler(
          error: error,
          retryCallback: () => ref.refresh(_cacheLoaderFutureProvider),
          stackTrace: st,
        ),
      ),
    );
  }
}

class LottieAnimationLoader extends StatelessWidget {
  const LottieAnimationLoader({super.key});

  @override
  Widget build(BuildContext context) {
    const loaders = [
      LottieAssets.femaleWalkingLottie,
      LottieAssets.movingBusLottie,
      LottieAssets.peopleTalkingLottie,
    ];
    final i = AppUtils.randomizer().nextInt(3);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          loaders[i],
          width: context.screenWidth,
        ),
      ),
    );
  }
}
