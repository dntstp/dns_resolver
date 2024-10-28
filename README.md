
Dart package that implements DNS over HTTPS client

## Features

This package provides a simple way to resolve DNS queries using DNS over HTTPS (DoH) protocol.
At the moment it supports Google Public DNS and Cloudflare Resolvers only.
Resolver class implements DnsCache, so subsequent queries for the same domain will be resolved from cache.
For simplicity, if the domain resolves to multiple IP addresses, only the last one will be returned.

TODO:
- [*] add support for Cloudflare 1.1.1.1

## Getting started
With dart
```` sh
dart pub add dns_resolver
````
This will add a line like this to your package's pubspec.yaml (and run an implicit dart pub get):
```` yaml
dependencies:
  dns_resolver: ^0.0.1
````

## Usage

``` dart
import 'package:dns_resolver/dns_resolver.dart';

void main() async {
  var resolver = GoogleDnsResolver();
  var record = await resolver.resolve(
    "www.apple.com",
    DnsRecordType.A,
  );
  print(record);
}
```