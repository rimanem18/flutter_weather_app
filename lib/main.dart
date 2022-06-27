import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/weather.dart';
import 'models/weather_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Weather> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = fetchWeather(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          WeatherPublished(),
          const WeatherListItem(
            areaNumber: 0,
          ),
          const WeatherListItem(
            areaNumber: 1,
          ),
          const WeatherListItem(
            areaNumber: 2,
          ),
          WeatherDetailText()
        ],
      ),
    ));
  }
}

class WeatherPublished extends StatelessWidget {
  Future<Weather> futureWeather = fetchWeather(0);

  @override
  Widget build(BuildContext context) {
    return (Center(
      child: FutureBuilder<Weather>(
        future: futureWeather,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Weather? s = snapshot.data;
            String code = s!.weatherCode;
            return Column(children: [
              Text(
                s.publishingOffice,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(s.reportDatetime),
            ]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    ));
  }
}

class WeatherListItem extends StatefulWidget {
  final int areaNumber;
  const WeatherListItem({super.key, required this.areaNumber});

  @override
  State<WeatherListItem> createState() => _WeatherListItemState();
}

class _WeatherListItemState extends State<WeatherListItem> {
  late Future<Weather> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = fetchWeather(widget.areaNumber);
  }

  @override
  Widget build(BuildContext context) {
    return (Center(
      child: FutureBuilder<Weather>(
        future: futureWeather,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Weather? s = snapshot.data;
            String code = s!.weatherCode;
            return Column(children: [
              ListTile(
                leading: Container(
                  alignment: Alignment.center,
                  width: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: NetworkImage(
                        "https://www.jma.go.jp/bosai/forecast/img/$code.png",
                      ),
                    ),
                  ),
                ),
                title: Text(s.areaName),
                subtitle: Text(s.wind),
              )
            ]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    ));
  }
}

class WeatherDetailText extends StatelessWidget {
  Future<WeatherDetail> futureWeatherDetail = fetchWeatherDetail();

  WeatherDetailText({super.key});

  @override
  Widget build(BuildContext context) {
    return (Center(
      child: FutureBuilder<WeatherDetail>(
        future: futureWeatherDetail,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            WeatherDetail? s = snapshot.data;
            String text = s!.text;
            return Center(child: Text(text));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    ));
  }
}

Future<Weather> fetchWeather(int areaNumber) async {
  final res = await http.get(Uri.parse(
      "https://www.jma.go.jp/bosai/forecast/data/forecast/200000.json"));
  if (res.statusCode == 200) {
    String resbody = utf8.decode(res.bodyBytes);
    return Weather.fromJson(jsonDecode(resbody)[0], areaNumber);
  } else {
    throw Exception("Failed to load Weather");
  }
}

Future<WeatherDetail> fetchWeatherDetail() async {
  final res = await http.get(Uri.parse(
      "https://www.jma.go.jp/bosai/forecast/data/overview_forecast/200000.json"));
  if (res.statusCode == 200) {
    String resbody = utf8.decode(res.bodyBytes);
    return WeatherDetail.fromJson(jsonDecode(resbody));
  } else {
    throw Exception("Failed to load WeatherDetail");
  }
}
