import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_pagination/text_pagination.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String rawText = '';
  bool isDone = false;
  int currentPage = 0;
  double fontSize = 26.0;

  @override
  void initState() {
    _incrementCounter();
    super.initState();
  }

  void _incrementCounter() async {
    rawText = await rootBundle.loadString('assets/Lorem ipsum.txt');
    double height = MediaQueryData.fromWindow(window).size.height;
    double padding = MediaQueryData.fromWindow(window).padding.top +
        MediaQueryData.fromWindow(window).padding.bottom +
        204.0;
    height -= padding;
    double width = MediaQueryData.fromWindow(window).size.width;
    setState(() {
      isDone = Pagination.setPage(rawText, height, width, 'Roboto', fontSize,
          3.0, 1.5, TextDirection.rtl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: isDone
                  ? Text(
                      Pagination.pageText(currentPage),
                      style: TextStyle(
                          fontSize: fontSize, letterSpacing: 3.0, height: 1.5),
                      textDirection: TextDirection.rtl,
                    )
                  : Text(
                      'Loading...',
                      style: TextStyle(
                          fontSize: fontSize, letterSpacing: 3.0, height: 1.5),
                    ),
            ),
          ),
          BottomAppBar(
            child: Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.font_download,
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        isDone = false;
                        fontSize = 26.0;
                        isDone = Pagination.setStyle(
                            'Roboto', fontSize, 3.0, 1.5, TextDirection.rtl);
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.font_download,
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        isDone = false;
                        fontSize = 32.0;
                        isDone = Pagination.setStyle(
                            'Roboto', fontSize, 3.0, 1.5, TextDirection.rtl);
                      });
                    }),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            switch (index) {
              case 0:
                currentPage = 0;
                break;
              case 1:
                if (currentPage > 0) currentPage--;
                break;
              case 2:
                if (currentPage < Pagination.pageLength() - 1) currentPage++;
                break;
              case 3:
                currentPage = Pagination.pageLength() - 1;
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.first_page),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.navigate_before),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.navigate_next),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.last_page),
          ),
        ],
      ),
    );
  }
}
