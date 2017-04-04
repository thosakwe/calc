import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:calc/calc.dart';

const String PROMPT = 'Enter an equation: ';

main() {
  stdout.write(PROMPT);
  StreamSubscription<String> sub;

  sub = stdin
      .transform(UTF8.decoder)
      .transform(new LineSplitter())
      .listen((line) {
    try {
      var parser = parse(line);
      var result = parser.expression().solve();
      print('Result: $result');
      stdout.write(PROMPT);
    } catch (e, st) {
      sub.cancel();
      stderr..writeln('Whoops, something went wrong.')..writeln(e)..writeln(st);
      exit(1);
    }
  });
}
