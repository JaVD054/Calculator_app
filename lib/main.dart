import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  var userInput = '0';
  var answer = '';

  List<List> history = [];
  final List<String> buttons = [
    'C',
    'DEL',
    'M-',
    '+',
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    'x',
    '1',
    '2',
    '3',
    '-',
    '',
    '0',
    '.',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
              child: Scrollbar(
                  child: ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: history.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            onTap: () {
                              setState(() {
                                userInput += history[index][1];
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 5),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${history[index][0]}\n=${history[index][1]}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 25),
                                  textAlign: TextAlign.right,
                                )));
                      }))),
          Container(
              padding: const EdgeInsets.fromLTRB(5, 5, 30, 5),
              alignment: Alignment.centerRight,
              child: Text(
                userInput,
                style: const TextStyle(fontSize: 37, color: Colors.white),
              )),
          Container(
              padding: const EdgeInsets.fromLTRB(5, 5, 30, 5),
              alignment: Alignment.centerRight,
              child: Text(
                answer,
                style: const TextStyle(fontSize: 30, color: Colors.white),
              )),
          GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.5,
              ),
              itemCount: buttons.length,
              itemBuilder: (BuildContext context, int index) {
                if (index != 16) {
                  return CalcButton(
                      text: buttons[index],
                      textColor: isOperator(buttons[index])
                          ? Colors.deepOrange
                          : Colors.white,
                      buttonTapped: () {
                        setState(() {
                          if (index == 0) {
                            userInput = '0';
                            answer = '';
                          } else if (index == 1 && userInput != '0') {
                            userInput =
                                userInput.substring(0, userInput.length - 1);
                          } else if (index == 19) {
                            if (userInput != '0' || answer != '') {
                              try {
                                equalTo();
                              } catch (e) {
                                print(e);
                                answer = 'Error';
                                return;
                              }
                              history.insert(0, [userInput, answer]);
                            }
                            //print(history);
                          } else if (index == 2) {
                            history = [];
                          } else if (userInput == '0' &&
                              index != 7 &&
                              index != 11) {
                            userInput = buttons[index];
                          } else if (userInput == '0' &&
                              (index == 7 || index == 11)) {
                          } else if (userInput.length <= 15) {
                            userInput += buttons[index];
                          }
                        });
                      });
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }

  void equalTo() {
    String finalUserInput = userInput;
    finalUserInput = userInput.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finalUserInput);

    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    answer = isInt(eval) ? eval.toInt().toString() : eval.toString();
  }
}

bool isOperator(String x) {
  if (x == '/' ||
      x == 'x' ||
      x == '-' ||
      x == '+' ||
      x == 'C' ||
      x == 'DEL' ||
      x == 'M-' ||
      x == '%') {
    return true;
  }
  return false;
}

class CalcButton extends StatelessWidget {
  final text;
  final buttonTapped;
  final textColor;

  const CalcButton({Key? key, this.text, this.textColor, this.buttonTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Ink(
            decoration: BoxDecoration(
                color: isEqual(text) ? Colors.deepOrange : Colors.transparent,
                shape: BoxShape.circle),
            child: InkWell(
                customBorder: const CircleBorder(),
                onTap: buttonTapped,
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 30,
                      color: textColor,
                    ),
                  ),
                ))));
  }
}

bool isInt(num x) {
  if (x == x.toInt()) {
    return true;
  } else {
    return false;
  }
}

bool isEqual(String x) {
  if (x == '=') {
    return true;
  } else {
    return false;
  }
}
