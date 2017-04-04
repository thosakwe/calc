import 'package:compiler_tools/compiler_tools.dart';
import 'expression.dart';
import 'token_type.dart';

const Map<TokenType, PrefixParselet> PREFIX_PARSELETS = const {
  TokenType.NUMBER: const _NumberParselet()
};

const Map<TokenType, InfixParselet> INFIX_PARSELETS = const {
  TokenType.CARET: const _CaretParselet()
};

abstract class PrefixParselet {
  Expression parse(Parser parser, Token token);
}

abstract class InfixParselet {
  Expression parse(Parser parser, Expression left, Token token);
  int get precedence;
}

class Parser extends BaseParser<TokenType> {
  Parser(List<Token<TokenType>> tokens) : super(tokens);

  int _getPrecedence() {
    try {
      InfixParselet parser = INFIX_PARSELETS[peek()?.type];
      if (parser != null) return parser.precedence;
      return 0;
    } catch (e) {
      return 0;
    }
  }

  Expression expression([int precedence = 0]) {
    Token<TokenType> token = read();
    var prefix = PREFIX_PARSELETS[token?.type];

    if (prefix == null) throw error('Could not parse "${token.text}".');

    var left = prefix.parse(this, token);

    while (precedence < _getPrecedence()) {
      token = read();
      var infix = INFIX_PARSELETS[token?.type];
      if (infix != null)
        left = infix.parse(this, left, token);
      else
        backtrack();
    }

    return left;
  }

  ParentheticalExpression parentheticalExpression() {
    if (next(TokenType.LPAREN)) {
      var LPAREN = current;
      var expr = expression();
      if (expr != null && next(TokenType.RPAREN)) {
        return new ParentheticalExpression(LPAREN, expr, current);
      } else
        throw error('Expected an expression.');
    } else
      return null;
  }
}

class _NumberParselet implements PrefixParselet {
  const _NumberParselet();

  @override
  Expression parse(Parser parser, Token token) =>
      token.type == TokenType.NUMBER ? new NumericalExpression(token) : null;
}

class _CaretParselet implements InfixParselet {
  const _CaretParselet();

  @override
  int get precedence => 0;

  @override
  Expression parse(Parser parser, Expression left, Token token) =>
      token.type == TokenType.CARET
          ? new BinaryExpression(left, token, parser.expression())
          : null;
}
