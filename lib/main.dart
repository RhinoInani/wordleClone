import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordle/const.dart';

List<String> allWords = [""];

Future<void> processWords() async {
  final path = await rootBundle.loadString('assets/5words.txt');
  allWords = path.split('\n');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await processWords();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  String word = allWords[Random().nextInt(allWords.length)];
  List<String> userInput = [""];
  List<String> userLetters = List.generate(30, (index) => "");
  List<Color> userColor = List.generate(30, (index) => Colors.grey[900]);
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color main = Colors.grey[900];

    Color textColor(String text) {
      try {
        if (userColor[userLetters.indexOf(text)] == Color(0xff388e3c)) {
          return Colors.green[700];
        } else if (userColor[userLetters.indexOf(text.toLowerCase())] ==
            Color(0xffffb74d)) {
          return Colors.orange[300];
        } else {
          return Colors.grey[300];
        }
      } catch (e) {
        return Colors.grey[900];
      }
    }

    GestureDetector buildTextBox(String text, Size size) {
      Color background = Colors.grey[900];

      return GestureDetector(
        onTap: () {
          String currentWord = userInput.last;
          if (text == '→' &&
              currentWord.length == 5 &&
              allWords.contains(currentWord.toLowerCase())) {
            int temp = counter - 5;
            for (int i = 0; i < word.length; i++) {
              if (word[i] == userLetters[temp].toLowerCase()) {
                setState(() {
                  userColor[temp] = Colors.green[700];
                  // background = textColor(text);
                });
              } else if (word.contains(userLetters[temp].toLowerCase())) {
                setState(() {
                  userColor[temp] = Colors.orange[300];
                  // background = textColor(text);
                });
              }
              temp++;
            }
            userInput.add("");
          } else if (text == '←' &&
              (counter % 5 != 0 ||
                  !allWords.contains(currentWord.toLowerCase()))) {
            userInput.last = currentWord.substring(0, currentWord.length - 1);
            setState(() {
              userLetters[counter - 1] = "";
              counter--;
            });
          } else {
            if (currentWord.length < 5 && text != '←' && text != '→') {
              userInput.last = currentWord + text;
              setState(() {
                userLetters[counter] = text;
                counter++;
              });
            }
          }
          print(userInput.last);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: background,
              border: Border.all(
                color: Colors.grey[700],
                width: 1,
              )),
          child: SizedBox(
            height: size.height * 0.2,
            width: size.height * 0.1,
            child: Center(
                child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
              ),
            )),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: main,
      appBar: AppBar(
        backgroundColor: main,
        shadowColor: Colors.white,
        elevation: 1,
        title: Text(
          "Wordle",
          style: TextStyle(
            color: Colors.white,
            fontSize: size.height * 0.03,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        )),
        actions: [
          IconButton(
            tooltip: "Reset",
            splashRadius: 1,
            onPressed: () {
              setState(() {
                word = allWords[Random().nextInt(allWords.length)];
                userInput = [""];
                userLetters = List.generate(30, (index) => "");
                userColor = List.generate(30, (index) => Colors.grey[900]);
                counter = 0;
              });
            },
            icon: Icon(
              CupertinoIcons.restart,
            ),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(size.height * 0.015),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return LetterBox(
                    letter: userLetters[index],
                    color: userColor[index],
                  );
                },
                childCount: userLetters.length,
              ),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: size.width / 5,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              top: size.height * 0.05,
              left: size.width * 0.03,
              right: size.width * 0.03,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return buildTextBox(text1[index], size);
                },
                childCount: 10,
              ),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: size.width / 14,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.65,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              top: size.height * 0.01,
              left: size.width * 0.06,
              right: size.width * 0.05,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return buildTextBox(text2[index], size);
                },
                childCount: 9,
              ),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: size.width / 13,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.75,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              top: size.height * 0.01,
              left: size.width * 0.06,
              right: size.width * 0.05,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return buildTextBox(text3[index], size);
                },
                childCount: 9,
              ),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: size.width / 13,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.75,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LetterBox extends StatelessWidget {
  const LetterBox({
    Key key,
    this.letter,
    this.color,
  }) : super(key: key);
  final String letter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: color,
          border: Border.all(
            color: Colors.grey[700],
            width: 1,
          )),
      child: SizedBox(
        height: size.height * 0.1,
        width: size.height * 0.1,
        child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              letter,
              style: TextStyle(
                color: Colors.white,
              ),
            )),
      ),
    );
  }
}
