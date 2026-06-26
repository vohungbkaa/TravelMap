import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:travel_map/shared/app_database.dart';
import 'package:travel_map/shared/network/api_client_factory.dart';
import 'package:travel_map/shared/network/auth_interceptor.dart';
import 'package:travel_map/shared/network/auth_token_provider.dart';

List<SingleChildWidget> get baseModule {
  return [
    Provider.value(value: const ApiClientFactory()),
    Provider<InMemoryAuthTokenProvider>(
      create: (context) => InMemoryAuthTokenProvider(),
    ),
    Provider<AuthTokenProvider>(
      create: (context) => context.read<InMemoryAuthTokenProvider>(),
    ),
    Provider(
      create: (context) => AuthInterceptor(
        tokenProvider: context.read<AuthTokenProvider>(),
      ),
    ),
    Provider(
      create: (context) => AppDatabase(),
      dispose: (context, database) => database.close(),
    ),
  ];
}
