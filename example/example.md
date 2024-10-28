## Basic Usage

Resolver will return DnsRecord or null if the domain is not found or error occurred.
Take care about null safety.

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

## Custom Resolver

You may create a custom resolver by extending the Resolver class by baseUrl.
Service must implement the DNS over HTTPS protocol with application/dns-json response type.
``` dart
import 'package:dns_resolver/dns_resolver.dart';

class MyResolver extends Resolver {
  @override
  String baseUrl = 'https://my.custom.service/dns-query';
}
```