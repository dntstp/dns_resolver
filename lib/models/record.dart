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

DnsRecordType decodeType(int googleType) {
  switch (googleType) {
    case 1:
      return DnsRecordType.A;
    case 2:
      return DnsRecordType.NS;
    case 5:
      return DnsRecordType.CNAME;
    case 6:
      return DnsRecordType.SOA;
    case 15:
      return DnsRecordType.MX;
    case 16:
      return DnsRecordType.TXT;
    case 28:
      return DnsRecordType.AAAA;
    case 33:
      return DnsRecordType.SRV;
    case 257:
      return DnsRecordType.CAA;
    default:
      return DnsRecordType.A;
  }
}

class DnsRecord {
  final String name;
  final DnsRecordType type;
  final int maxTTL;
  final String data;
  final DateTime updated = DateTime.now();

  int get ttl => maxTTL - DateTime.now().difference(updated).inSeconds;

  bool get isExpired => ttl < 0;

  DnsRecord({
    required this.name,
    required this.type,
    required this.maxTTL,
    required this.data,
  });

  @override
  String toString() {
    return 'DnsRecord(name: $name, type: $type, ttl: $ttl, value: $data)';
  }

  factory DnsRecord.fromJson(Map<String, dynamic> json) => DnsRecord(
        name: json["name"],
        type: decodeType(json["type"]),
        maxTTL: json["TTL"],
        data: json["data"],
      );
}
