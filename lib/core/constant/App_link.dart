class ServerConfig {
  static final ServerConfig _instance = ServerConfig._internal();

  factory ServerConfig() => _instance;

  ServerConfig._internal();

  String _serverLink = "https://2d6b-169-150-196-105.ngrok-free.app/api";

  String get serverLink => _serverLink;

  void updateServerLink(String newLink) {
    _serverLink = newLink;
  }
}
