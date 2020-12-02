import 'package:flutter/material.dart';
import 'package:migsmarketplace/constants.dart';
import 'package:migsmarketplace/screens/login.dart';
import 'package:migsmarketplace/screens/register.dart';
import 'package:migsmarketplace/services/navigation.dart';
import 'package:migsmarketplace/components/custom_round_button.dart';

class WelcomeScreen extends StatelessWidget {

  static const String id = '/welcome';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NavigationServices _nav = NavigationServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 142.0,
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                    child: Image.asset('assets/images/icon.jpg'),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 120.0),
            Text(
              'Welcome to \n Migs Marketplace',
              style: kH2Blue,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 120.0),
            CustomRoundButton(
              buttonTitle: 'Log In',
              buttonColor: kMainThemeColor,
              onPressed: () {
                Navigator.of(context).push(_nav.createRoute(LoginScreen()));
              },
            ),
            SizedBox(height: 48.0),
            CustomRoundButton(
              buttonTitle: 'Register',
              buttonColor: kSecondaryThemeColor,
              onPressed: () {
                Navigator.of(context).push(_nav.createRoute(RegisterScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}