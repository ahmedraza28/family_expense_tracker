import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calculator_provider.codegen.g.dart';

final numberResultProvider = StateProvider.autoDispose<double>((ref) => 0);

final calculationHistoryProvider = StateProvider.autoDispose<List<String>>(
  (ref) => [],
);

@riverpod
class NumberInput extends _$NumberInput {
  @override
  String build() => '0';

  void onBtnTapped(String button) {
    state += button;
  }

  void clear() {
    state = '0';
    ref.read(numberResultProvider.notifier).state = 0;
  }

  void delete() {
    state = state.substring(0, state.length - 1);
  }

  void ans() {
    final result = ref.read(numberResultProvider);
    state += result.toString();
  }

  void equal() {
    final input = state.replaceAll('x', '*');
    final expression = Parser().parse(input);
    final eval = expression.evaluate(
      EvaluationType.REAL,
      ContextModel(),
    ) as double;

    if (eval == ref.read(numberResultProvider)) {
      return;
    } else if (eval == double.infinity) {
      state = '0';
    } else {
      state = eval.toString();
    }

    // update output
    ref.read(numberResultProvider.notifier).state = eval;

    // update expression history
    ref
        .read(calculationHistoryProvider.notifier)
        .update((prevState) => prevState = [state, ...prevState]);
  }
}
