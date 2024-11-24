class Define {
  static const bool inProduction =
      bool.fromEnvironment("dart.vm.product");
  static const String appName =
      String.fromEnvironment("DEFINE_APP_DISPLAY_NAME", defaultValue: "XTL");
  static const String appEnv =
      String.fromEnvironment("DEFINE_ENV", defaultValue: "prod");
}
