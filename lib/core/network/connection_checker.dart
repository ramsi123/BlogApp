import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionChecker {
  // Getter function to check whether the device is connected to internet or no.
  Future<bool> get isConnected;
}

class ConnectionCheckerImpl implements ConnectionChecker {
  final InternetConnection internetConnection;

  ConnectionCheckerImpl(this.internetConnection);

  @override
  Future<bool> get isConnected async =>
      await internetConnection.hasInternetAccess;
}
