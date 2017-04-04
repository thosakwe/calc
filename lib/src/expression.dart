import 'dart:math' as math;
import 'package:compiler_tools/compiler_tools.dart';
import 'token_type.dart';

abstract class Expression {
  num solve();
}

class NumericalExpression implements Expression {
  final Token<TokenType> NUMBER;

  NumericalExpression(this.NUMBER);

  @override
  num solve() => num.parse(NUMBER.text);
}

class ParentheticalExpression implements Expression {
  final Token<TokenType> LPAREN, RPAREN;
  final Expression expression;

  ParentheticalExpression(this.LPAREN, this.expression, this.RPAREN);

  @override
  num solve() => expression.solve();
}

class BinaryExpression implements Expression {
  final Token<TokenType> OPERATOR;
  final Expression left, right;

  BinaryExpression(this.left, this.OPERATOR, this.right);

  @override
  num solve() {
    switch (OPERATOR.text) {
      case '^':
        return math.pow(left.solve(), right.solve());
      case '*':
        return left.solve() * right.solve();
      case '/':
        return left.solve() / right.solve();
      case '+':
        return left.solve() + right.solve();
      case '-':
        return left.solve() - right.solve();
    }

    return null;
  }
}
