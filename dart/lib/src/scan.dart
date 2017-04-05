import 'package:compiler_tools/compiler_tools.dart';
import 'package:string_scanner/string_scanner.dart';
import 'token_type.dart';

final Map<Pattern, TokenType> _patterns = {
  '(': TokenType.LPAREN,
  ')': TokenType.RPAREN,
  '^': TokenType.CARET,
  '*': TokenType.ASTERISK,
  '/': TokenType.SLASH,
  '+': TokenType.PLUS,
  '-': TokenType.MINUS,
  new RegExp(r'(-?[0-9]+(\.[0-9]+)?)|(-?\.([0-9]+))'): TokenType.NUMBER
};

List<Token<TokenType>> scan(String text, {sourceUrl}) {
  List<Token<TokenType>> tokens = [];
  var scanner = new SpanScanner(text, sourceUrl: sourceUrl);

  while (!scanner.isDone) {
    List<Token<TokenType>> potential = [];

    _patterns.forEach((k, v) {
      if (scanner.matches(k))
        potential.add(new Token(v, span: scanner.lastSpan));
    });

    if (potential.isEmpty) {
      scanner.readChar();
    } else {
      potential.sort((a, b) => b.text.length.compareTo(a.text.length));
      var token = potential.first;
      tokens.add(token);
      scanner.scan(token.text);
    }
  }

  return tokens;
}
