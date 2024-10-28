
Dart package that implements DNS over HTTPS client

## Features

This package provides a simple way to resolve DNS queries using DNS over HTTPS (DoH) protocol.
At the moment it supports Google Public DNS and Cloudflare Resolvers only.
Resolver class implements DnsCache, so subsequent queries for the same domain will be resolved from cache.
For simplicity, if the domain resolves to multiple IP addresses, only the last one will be returned.

TODO:
- [*] Implement dns-json models
- [*] add support for Cloudflare 1.1.1.1
- [*] add support for Google Public DNS
- [*] add support for custom resolvers

## Getting started
Install with dart
```` sh
dart pub add dns_resolver
````
This will add a line like this to your package's pubspec.yaml (and run an implicit dart pub get):
```` yaml
dependencies:
  dns_resolver: ^0.1.1
````



