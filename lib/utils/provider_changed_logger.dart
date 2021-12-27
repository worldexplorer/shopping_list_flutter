// https://riverpod.dev/docs/concepts/provider_observer/

import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProviderChangedLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}
