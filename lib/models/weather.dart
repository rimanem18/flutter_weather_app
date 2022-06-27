class Weather {
  final String publishingOffice;
  final String reportDatetime;
  final String areaName;
  final String weatherCode;
  final String wind;

  Weather({
    required this.publishingOffice,
    required this.reportDatetime,
    required this.areaName,
    required this.weatherCode,
    required this.wind,
  });

  factory Weather.fromJson(Map<String, dynamic> json, int areaNumber) {
    var n = areaNumber;
    var area = json["timeSeries"][0]["areas"][n];
    return Weather(
      publishingOffice: json["publishingOffice"],
      reportDatetime: json["reportDatetime"],
      areaName: area["area"]["name"],
      weatherCode: area["weatherCodes"][0],
      wind: area["winds"][0],
    );
  }
}
