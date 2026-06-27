enum EnvConfig {
  test,
  release,
}

// ignore: constant_identifier_names, keep the backend config name explicit.
const BASE_URL_DEFAULT = 'https://jsonplaceholder.typicode.com';

class FeatureEnv {
  const FeatureEnv({
    this.testUrl = BASE_URL_DEFAULT,
    this.releaseUrl = BASE_URL_DEFAULT,
  });

  static EnvConfig currentEnv = EnvConfig.release;

  final String testUrl;
  final String releaseUrl;

  String getBaseUrl() {
    return switch (currentEnv) {
      EnvConfig.test => testUrl,
      EnvConfig.release => releaseUrl,
    };
  }
}

enum FeatureConfig {
  auth(FeatureEnv()),
  user(FeatureEnv(
    testUrl: 'https://api.github.com',
    releaseUrl: 'https://api.github.com',
  )),
  trip(FeatureEnv());

  const FeatureConfig(this.env);
  final FeatureEnv env;

  String get baseUrl => env.getBaseUrl();
}
