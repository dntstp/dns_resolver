import 'dart:convert';

import 'package:dns_resolver/models/question.dart';
import 'package:dns_resolver/models/record.dart';

class DnsResponse {
  int status;
  bool tc;
  bool rd;
  bool ra;
  bool ad;
  bool cd;
  List<DnsQuestion> question;
  List<DnsRecord> answer;

  DnsResponse({
    required this.status,
    required this.tc,
    required this.rd,
    required this.ra,
    required this.ad,
    required this.cd,
    required this.question,
    required this.answer,
  });

  factory DnsResponse.fromJson(Map<String, dynamic> json) => DnsResponse(
    status: json["Status"],
    tc: json["TC"],
    rd: json["RD"],
    ra: json["RA"],
    ad: json["AD"],
    cd: json["CD"],
    question: List<DnsQuestion>.from(json["Question"].map((x) => DnsQuestion.fromJson(x))),
    answer: List<DnsRecord>.from((json["Answer"] ?? []).map((x) => DnsRecord.fromJson(x))),
  );

}

