import 'package:flutter/material.dart';
import 'package:flutter_app/chart.dart';
import 'package:flutter_app/diary.dart';
import 'package:intl/intl.dart';
//import 'package:high_chart/high_chart.dart';
import 'package:intl/date_symbol_data_local.dart';
//사용하는 모든 페이지를 import 해주세요!

void main() {
  Intl.defaultLocale = 'ko_KR';
  initializeDateFormatting().then((_) => runApp(Main()));
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Table Calendar Demo',   
      theme: ThemeData(
        primarySwatch: Colors.green,
        canvasColor: Colors.white,
        accentColor: Colors.redAccent,
      ),
      home: MyHomePage(title: 'EZfit'),
      routes: {
        'chart': (context) =>
            Chart(), //이렇게 하면 다른 페이지에서는 LoginPage 클래스를 login으로 호출할 수 있게 됩니다!
        'diary': (context) => MyHomePage(),
      },
    );
  }
}
