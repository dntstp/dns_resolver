class DnsQuestion {
  String name;
  int type;

  DnsQuestion({
    required this.name,
    required this.type,
  });

  factory DnsQuestion.fromJson(Map<String, dynamic> json) => DnsQuestion(
    name: json["name"],
    type: json["type"],
  );

}