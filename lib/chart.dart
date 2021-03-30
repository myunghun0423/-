import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:high_chart/high_chart.dart';
import 'package:http/http.dart' as http;

class Chart extends StatefulWidget {
  @override
  ChartState createState() => ChartState();
}

class ChartState extends State<Chart> {
  static var response_data;
  List _chart1;
  List _chart2;
  List<dynamic> _chart3;

  Future getData2() async {
    final response =
        await http.get("http://13.209.17.162/app_test01/diaryjson.php");
    String namu2 = "abc";
    namu2 = "abc";
    String jsondata2 = response.body;
    Map<String, dynamic> _chartitems = jsonDecode(jsondata2); // food_date어떻게 까지

    _chart1 = _chartitems['response']['body']['food'];

    for (var i = 0; i < _chart1.length; i++) {
      _chart2 =
          jsonDecode(_chartitems['response']['body']['food'][i]['food_json']);

      for (var j = 0; j < _chart2.length; j++) {
        _chart3 = [(_chart2[j]['protein'])];

        print(_chart3);
      }
    }
    response_data = '''{
      title: {
          text: '평균 영양 섭취량'
      },
      xAxis: {
          categories: ['12월 8일', '12월 13일', '12월 18일', '12월 20일', '12월 27일', '12월28일', '12월 29일', '12월 30일', '12월 31일']
      },
      labels: {
          items: [{
              html: '',
              style: {
                  left: '50px',
                  top: '18px',
                  
                  color: ( // theme
                      Highcharts.defaultOptions.title.style &&
                      Highcharts.defaultOptions.title.style.color
                  ) || 'black'
              }
          }]
      },
      series: [{
          type: 'column',
          name: 'sugar',
          data: [3, 5, 7, 9, 5, 6, 8, 7, 4]
      }, {
          type: 'column',
          name: 'protein',
          data: [2, 3, 5, 7, 6, 7, 3, 7, 2]
      }, {
          type: 'column',
          name: 'sodium',
          data: [4, 3, 3, 9, 5, 9, 5, 5, 1]
      }, {
        type: 'column',
        name: 'fat',
        data: [6, 7, 7, 8 ,9, 7, 8, 9, 11]
      },{
        type: 'column',
        name: 'carbonhydrate',
        data: [8, 9, 9, 7, 7, 8, 5, 2]

      },{
          type: 'spline',
          name: '평균',
          data: [3, 2.67, 3, 6.33, 3.33, 4.56, 3.77, 6.98, 7.55],
          marker: {
              lineWidth: 2,
              lineColor: Highcharts.getOptions().colors[3],
              fillColor: 'white'

          }
      
        }]
    }''';
  }

  main() {
    var _chart_data = 'abc';
    var _chart_data2 = 'abc';

    _chart_data2 = response_data;
    _chart_data = '''{
      title: {
          text: '평균 영양 섭취량'
      },
      xAxis: {
          categories: ['12월 8일', '12월 13일', '12월 18일', '12월 20일', '12월 27일', '12월28일', '12월 29일', '12월 30일', '12월 31일']
      },
      labels: {
          items: [{
              html: '',
              style: {
                  left: '50px',
                  top: '18px',
                  
                  color: ( // theme
                      Highcharts.defaultOptions.title.style &&
                      Highcharts.defaultOptions.title.style.color
                  ) || 'black'
              }
          }]
      },
      series: [{
          type: 'column',
          name: 'sugar',
          data: [3, 5, 7, 9, 5, 6, 8, 7, 4]
      }, {
          type: 'column',
          name: 'protein',
          data: [2, 3, 5, 7, 6, 7, 3, 7, 2]
      }, {
          type: 'column',
          name: 'sodium',
          data: [4, 3, 3, 9, 5, 9, 5, 5, 1]
      }, {
        type: 'column',
        name: 'fat',
        data: [6, 7, 7, 8 ,9, 7, 8, 9, 11]
      },{
        type: 'column',
        name: 'carbonhydrate',
        data: [8, 9, 9, 7, 7, 8, 5, 2]

      },{
          type: 'spline',
          name: '평균',
          data: [3, 2.67, 3, 6.33, 3.33, 4.56, 3.77, 6.98, 7.55],
          marker: {
              lineWidth: 2,
              lineColor: Highcharts.getOptions().colors[3],
              fillColor: 'white'

          }
      
        }]
    }''';
    return _chart_data2;
  }

  @override
  void initState() {
    super.initState();
    this.getData2();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('EZfit'),
          backgroundColor: Colors.green,
          leading: Icon(Icons.bar_chart),
        ),
        body: Center(
          child: HighCharts(
            data: main(),
          ),
        ),
      ),
    );
  }
}
