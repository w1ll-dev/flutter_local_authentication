import 'package:flutter/material.dart';
import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  @override
  initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    if (await _isBiometricAvilable()) {
      await _getListOfBiometricTypes();
      await _authenticate();
    }
  }

  Future<bool> _isBiometricAvilable() async {
    bool isAvilable = false;
    try {
      return isAvilable = await _localAuthentication.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics = [];
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate.",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: Center(
        child: Text("Login"),
      ),
    );
  }
}
