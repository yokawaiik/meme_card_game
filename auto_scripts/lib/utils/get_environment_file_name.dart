String getEnvironmentFileName({bool isRelease = false}) {
  if (isRelease) {
    return '.env.production.yaml';
  } else {
    return '.env.development.yaml';
  }
}
