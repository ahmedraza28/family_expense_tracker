import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calculator_provider.codegen.g.dart';

final numberResultProvider = StateProvider.autoDispose<String>((ref) => '0');

final calculationHistoryProvider = StateProvider.autoDispose<List<String>>(
  (ref) => [],
);

@riverpod
class NumberInput extends _$NumberInput {
  @override
  String build() => '0';

  void onBtnTapped(String button) {
    if (state == '0') {
      state = button;
    } else {
      state += button;
    }
  }

  void clear() {
    state = '0';
    ref.read(numberResultProvider.notifier).state = '0';
  }

  void delete() {
    state = state.substring(0, state.length - 1);
  }

  void ans() {
    final result = ref.read(numberResultProvider);
    state += result;
  }

  void equal() {
    final input = state.replaceAll('x', '*');
    final expression = Parser().parse(input);
    final eval = expression.evaluate(
      EvaluationType.REAL,
      ContextModel(),
    ) as double;

    state = eval.toString();

    // update output
    ref.read(numberResultProvider.notifier).state = state;

    // update expression history
    ref
        .read(calculationHistoryProvider.notifier)
        .update((prevState) => prevState = [state, ...prevState]);
  }
}
