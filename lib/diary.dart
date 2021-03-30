//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:http/http.dart' as http;

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Map<DateTime, List> _events = {};
  Map<String, dynamic> _test;

  List _test2;
  List _test3;
  List _selectedEvents;
  List mealtime = []; //B, L, D, N, S
  String food_date;

  AnimationController _animationController;
  CalendarController _calendarController;

  Future getData() async {
    final response =
        await http.post("https://namuintelligence.ga/month", headers: {
      'token':
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiJlemZpdCIsInVzZXJuYW1lIjoiZXpmaXQiLCJhZG1pbiI6InVzZXIuYWRtaW4iLCJpYXQiOjE2MTYxMzc0MjcsImV4cCI6MTYxNjc0MjIyNywiaXNzIjoibmFtdWludGVsbGlnZW5jZS5nYSIsInN1YiI6InRva2VuIn0.sq2zwDzZ-pjh-wGzzjEMInI3efpHz2pDWuPWGhL1_Bg"
    });

    String jsondata = response.body;
    Map<String, dynamic> _eventitems = jsonDecode(jsondata);

    _test2 = _eventitems['response']['body']['foodData'];

    for (var i = 0; i < _test2.length; i++) {
      _test3 = jsonDecode(
          _eventitems['response']['body']['foodData'][i]['food_json']);

      mealtime = [(_test2[i]['mealtime'])];
      if (mealtime == 'B') {}//조건 걸어서 아점저 출력 하려고 했는데 모르겠다
      food_date =
          (_test2[i]['food_date']).replaceAll('T', " ").replaceAll('.000Z', "");

      // 선언만 하면 주소값만 배정.  뒤에 []  선언해야 배열크기 까지 잡아줘서  exception null 이 안뜬다.
      List test4 = [];
      for (var j = 0; j < _test3.length; j++) {
        test4.insert(j, '${_test3[j]['name']}\n${_test3[j]['cal']}kcal');
      }

      _events[DateTime.parse(food_date)] = test4;
    }
  }

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    this.getData();

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        animatedIconTheme: IconThemeData(size: 22.0),
        curve: Curves.bounceIn,
        overlayColor: Colors.black38,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.camera),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            label: '카메라',
            onTap: () {},
          ),
          SpeedDialChild(
            child: Icon(Icons.bar_chart),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            label: '통계',
            onTap: () => Navigator.of(context).pushNamed('chart'),
          ),
          SpeedDialChild(
            child: Icon(Icons.animation),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            label: '추가예정',
            onTap: () {},

          ),
        ],
      ),
      appBar: AppBar(
        leading: Icon(Icons.av_timer_sharp),
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendar(),
          const SizedBox(height: 8.0),
          const SizedBox(height: 0.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.green[400],
        todayColor: Colors.green[200],
        markersColor: Colors.black26,
        outsideDaysVisible: false,

      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 16.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.green[700],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventList() {
    return new ListView.builder(
      itemCount: _selectedEvents.length,
      itemBuilder: (context, i) => ExpansionTile(
        leading: Icon(Icons.bookmark_outline_sharp),
        backgroundColor: Colors.blueGrey[50],
        title: new Text("식사기록"),
        children: _selectedEvents
            .map((event) => ListTile(
                  title: new Text(event),
                  onTap: () {},
                  leading: Text("이름:\n칼로리:"),
                  trailing: Icon(Icons.local_dining_rounded),
                  tileColor: Colors.white,
                ))
            .toList(),
      ),
    );
  }
}
