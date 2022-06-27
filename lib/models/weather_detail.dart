class WeatherDetail {
  final String publishingOffice;
  final String reportDatetime;
  final String targetArea;
  final String headlineText;
  final String text;

  WeatherDetail({
    required this.publishingOffice,
    required this.reportDatetime,
    required this.targetArea,
    required this.headlineText,
    required this.text,
  });

  factory WeatherDetail.fromJson(Map<String, dynamic> json) {
    return WeatherDetail(
      publishingOffice: json["publishingOffice"],
      reportDatetime: json["reportDatetime"],
      targetArea: json["targetArea"],
      headlineText: json["headlineText"],
      text: json["text"],
    );
  }
}
