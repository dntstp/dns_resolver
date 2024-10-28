import 'dart:convert';

import 'package:dns_resolver/models/record.dart';
import 'package:dns_resolver/models/response.dart';
import 'package:http/http.dart';

class DnsCache {
  final Map<String, DnsRecord> _cache = {};

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

class DnsHttpsResolver extends DnsCache {
  final String baseUrl = 'https://dns.google/resolve';
  final Client client = Client();

  Future<DnsRecord?> resolve(String name, DnsRecordType type) async {
    DnsRecord? record = _get(name, type);
    if (record != null) {
      return Future.value(record);
    }
    var uri = Uri.parse('$baseUrl?name=$name&type=${type.name}');
    var response = await client.get(uri, headers: {
      'accept': 'application/dns-json',
    });
    if (response.statusCode != 200) {
      Future.value(null);
    }
    var dnsResponse = DnsResponse.fromJson(json.decode(response.body));
    if (dnsResponse.status != 0) {
      return Future.value(null);
    }
    if (dnsResponse.answer.isEmpty) {
      return Future.value(null);
    }
    record = dnsResponse.answer.last;

    _set(name, type, record);

    return Future.value(record);
  }
}

class GoogleDnsResolver extends DnsHttpsResolver {
  @override
  String baseUrl = 'https://dns.google/resolve';
}

class CloudflareDnsResolver extends DnsHttpsResolver {
  @override
  String baseUrl = 'https://cloudflare-dns.com/dns-query';
}
