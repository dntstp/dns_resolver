<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Dart package that implements DNS over HTTPS client

## Features

This package provides a simple way to resolve DNS queries using DNS over HTTPS (DoH) protocol.
At the moment it supports Google Public DNS Resolver only.
Resolver class implements DnsCache, so subsequent queries for the same domain will be resolved from cache.
For simplicity, if the domain resolves to multiple IP addresses, only the last one will be returned.

TODO:
- [ ] add support for Cloudflare 1.1.1.1

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
  var resolver = GoogleResolver();
  var record = await resolver.resolve(
    "www.apple.com",
    DnsRecordType.A,
  );
  print(record);
}
```

<!-- ## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more. -->