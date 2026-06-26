enum EnvConfig {
  test,
  release,
}

// ignore: constant_identifier_names, keep the backend config name explicit.
const BASE_URL_DEFAULT = 'https://jsonplaceholder.typicode.com';

sealed class FeatureEnv {
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

final class FeatureAuthEnv extends FeatureEnv {
  const FeatureAuthEnv({
    super.testUrl,
    super.releaseUrl,
  });
}

final class FeatureUserEnv extends FeatureEnv {
  const FeatureUserEnv({
    super.testUrl,
    super.releaseUrl,
  });
}

final class FeatureTripEnv extends FeatureEnv {
  const FeatureTripEnv({
    super.testUrl,
    super.releaseUrl,
  });
}
