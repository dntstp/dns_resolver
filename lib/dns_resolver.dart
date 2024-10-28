import 'dart:convert';

import 'package:http/http.dart';

enum DnsRecordType {
  A,
  AAAA,
  CNAME,
  MX,
  TXT,
  NS,
  PTR,
  SOA,
  SRV,
  CAA,
}

class DnsRecord {
  final String name;
  final DnsRecordType type;
  final int maxTTL;
  final String data;
  final DateTime updated = DateTime.now();

  int get ttl => maxTTL - DateTime.now().difference(updated).inSeconds;
  bool get isExpired => ttl < 0;


  DnsRecord(this.name, this.type, this.maxTTL, this.data);

  @override
  String toString() {
    return 'DnsRecord(name: $name, type: $type, ttl: $ttl, value: $data)';
  }

}

class DnsCache {
  Map<String, DnsRecord> _cache = {};

  String _getKey(String name, DnsRecordType type) {
    return '$name:${type.name}';
  }

  DnsRecord? _get(String name, DnsRecordType type) {
    var key = _getKey(name, type);
    var record = _cache[key];
    if (record?.isExpired ?? false) {
      _cache.remove(key);
      return null;
    }
    return record;
  }

  void _set(String name, DnsRecordType type, DnsRecord record) {
    var key = _getKey(name, type);
    _cache[key] = record;
  }


}

class GoogleResolver extends DnsCache {
  final String baseUrl = 'https://dns.google/resolve';
  final Client client = Client();

  DnsRecordType decodeType(int googleType) {
    switch(googleType) {
      case 1: return DnsRecordType.A;
      case 2: return DnsRecordType.NS;
      case 5: return DnsRecordType.CNAME;
      case 6: return DnsRecordType.SOA;
      case 15: return DnsRecordType.MX;
      case 16: return DnsRecordType.TXT;
      case 28: return DnsRecordType.AAAA;
      case 33: return DnsRecordType.SRV;
      case 257: return DnsRecordType.CAA;
      default: return DnsRecordType.A;
    }

  }

  Future<DnsRecord?> resolve (String name, DnsRecordType type) async {

    DnsRecord? record = _get(name, type);
    if(record != null) {
      return Future.value(record);
    }
    var uri = Uri.parse('$baseUrl?name=$name&type=${type.name}');
    var response = await client.get(uri);
    if (response.statusCode != 200) {
      Future.value(null);
    }
    var data = json.decode(response.body) as Map<String, dynamic>;
    if (data['Answer'] == null) {
      return Future.value(null);
    }
    var answer = data['Answer'] as List<dynamic>;
    if (answer.isEmpty) {
      return Future.value(null);
    }
    var last = answer.last as Map<String, dynamic>;
    if (type != decodeType(last['type'] as int)) {
      return Future.value(null);
    }
    record = DnsRecord(
      name,
      decodeType(last['type'] as int),
      last['TTL'] as int,
      last['data'] as String,
    );
    _set(name, type, record);

    return Future.value(record);

  }

}