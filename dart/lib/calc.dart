import 'src/expression.dart';
import 'src/parser.dart';
import 'src/scan.dart';
import 'src/token_type.dart';

Parser parse(String text, {sourceUrl}) =>
    new Parser(scan(text, sourceUrl: sourceUrl));
