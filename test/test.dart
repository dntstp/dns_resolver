import 'dart:convert';
import 'package:dns_resolver/dns_resolver.dart';
import 'package:dns_resolver/models/record.dart';
import 'package:test/test.dart';

void main() {
  group('GoogleResolver tests', () {
    var resolvers = [
      GoogleDnsResolver(),
      CloudflareDnsResolver(),
    ];

    test('Test apple.com', () async {

      for (var resolver in resolvers) {
        var record = await resolver.resolve(
          "apple.com",
          DnsRecordType.A,
        );
        expect(record, isNotNull);
        expect(record!.ttl, greaterThan(0));
        expect(record!.isExpired, isFalse);
        expect(record.type, equals(DnsRecordType.A));
      }

    });

    test('Test NXDOMAIN', () async {
      for (var resolver in resolvers) {
        var record = await resolver.resolve(
          "this.is.not.a.domain",
          DnsRecordType.A,
        );
        expect(record, isNull);
      }
    });

    test('Test MX', () async {
      for (var resolver in resolvers) {
        var record = await resolver.resolve(
          "google.com",
          DnsRecordType.MX,
        );
        expect(record, isNotNull);
        expect(record!.ttl, greaterThan(0));
        expect(record!.isExpired, isFalse);
        expect(record.type, equals(DnsRecordType.MX));
      }
    });

    test('Test Cloudflare''s One One', () async {
      for (var resolver in resolvers) {
        var record = await resolver.resolve(
          "one.one.one.one",
          DnsRecordType.A,
        );
        expect(record, isNotNull);
        expect(record!.ttl, greaterThan(0));
        expect(record!.isExpired, isFalse);
        expect(record.type, equals(DnsRecordType.A));
        expect(record.data, isIn(['1.1.1.1', '1.0.0.1']));
      }
    });

  });
}