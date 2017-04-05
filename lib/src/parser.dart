import 'package:compiler_tools/compiler_tools.dart';
import 'expression.dart';
import 'token_type.dart';

const Map<TokenType, PrefixParselet> PREFIX_PARSELETS = const {
  TokenType.LPAREN: const _ParenthesisParselet(),
  TokenType.NUMBER: const _NumberParselet()
};

const Map<TokenType, InfixParselet> INFIX_PARSELETS = const {
  TokenType.CARET: const _BinaryInfixParselet(TokenType.CARET, 0),
  TokenType.ASTERISK: const _BinaryInfixParselet(TokenType.ASTERISK, 1),
  TokenType.SLASH: const _BinaryInfixParselet(TokenType.SLASH, 2),
  TokenType.PLUS: const _BinaryInfixParselet(TokenType.PLUS, 3),
  TokenType.MINUS: const _BinaryInfixParselet(TokenType.MINUS, 4)
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

    do {
      try {
      token = read();
      var infix = INFIX_PARSELETS[token?.type];
      if (infix != null)
        left = infix.parse(this, left, token);
      else
        backtrack();
      } catch(e) {
        break;
      }
    } while (precedence < _getPrecedence());

    return left;
  }
}

class _NumberParselet implements PrefixParselet {
  const _NumberParselet();

  @override
  Expression parse(Parser parser, Token token) =>
      token.type == TokenType.NUMBER ? new NumericalExpression(token) : null;
}

class _ParenthesisParselet implements PrefixParselet {
  const _ParenthesisParselet();

  @override
  Expression parse(Parser parser, Token token) {
    if (token.type == TokenType.LPAREN) {
      var expr = parser.expression();
      if (expr != null && parser.next(TokenType.RPAREN)) {
        return new ParentheticalExpression(token, expr, parser.current);
      } else
        throw parser
            .error('Expected an expression, found ${parser.current} instead.');
    } else
      return null;
  }
}

class _BinaryInfixParselet implements InfixParselet {
  final TokenType type;

  @override
  final int precedence;

  const _BinaryInfixParselet(this.type, this.precedence);

  @override
  Expression parse(Parser parser, Expression left, Token token) =>
      token.type == type
          ? new BinaryExpression(left, token, parser.expression())
          : null;
}
