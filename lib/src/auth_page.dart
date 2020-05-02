import 'package:flutter/material.dart';
import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart';

import 'details_page.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  AnimationController animController;
  bool _isValidPswd = false;
  TextEditingController _pswdController = TextEditingController();

  @override
  initState() {
    super.initState();
    animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _authenticate();
  }

  Future<void> _authenticate() async {
    if (await _isBiometricAvilable()) {
      await _getListOfBiometricTypes();
      await _authenticateUser();
    }
  }

  Future<bool> _isBiometricAvilable() async {
    bool isAvilable = false;
    try {
      isAvilable = await _localAuthentication.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    return isAvilable;
  }

  Future<void> _getListOfBiometricTypes() async {
    try {
      List<BiometricType> listOfBiometrics =
          await _localAuthentication.getAvailableBiometrics();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate.",
        useErrorDialogs: true,
        stickyAuth: true,
      );
      if (isAuthenticated)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Details(),
          ),
        );
    } catch (e) {
      print(e);
    }
  }

  Widget _pswdForm() => Padding(
        padding: EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _pswdController,
          onFieldSubmitted: (pswdSubmited) {
            if (pswdSubmited == "root") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Details(),
                ),
              );
            } else {
              animController.forward();
              _isValidPswd = false;
              _authenticate();
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            errorText: _isValidPswd ? null : "wrong password",
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(animController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animController.reverse();
            }
          });
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: Center(
        child: AnimatedBuilder(
            animation: offsetAnimation,
            builder: (buildContext, child) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 24.0),
                padding: EdgeInsets.only(
                    left: offsetAnimation.value + 24.0,
                    right: 24.0 - offsetAnimation.value),
                child: _pswdForm(),
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}
