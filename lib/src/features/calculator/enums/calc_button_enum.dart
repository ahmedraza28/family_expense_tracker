// ignore_for_file: constant_identifier_names

enum CalcButton {
  ZERO('0'),
  ONE('1'),
  TWO('2'),
  THREE('3'),
  FOUR('4'),
  FIVE('5'),
  SIX('6'),
  SEVEN('7'),
  EIGHT('8'),
  NINE('9'),
  DECIMAL('.'),
  CLEAR('C', isAction: true),
  DELETE('DEL', isAction: true),
  ANS('ANS', isAction: true),
  EQUAL('=', isAction: true),
  ADD('+', isOperator: true),
  SUBTRACT('-', isOperator: true),
  MULTIPLY('x', isOperator: true),
  DIVIDE('/', isOperator: true),
  PERCENT('%', isOperator: true);

  final bool isOperator;
  final bool isAction;
  final String label;

  const CalcButton(
    this.label, {
    this.isOperator = false,
    this.isAction = false,
  });
}
