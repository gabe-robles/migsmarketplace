import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:migsmarketplace/models/user.dart';
import 'package:migsmarketplace/screens/navigation.dart';
import 'package:migsmarketplace/screens/welcome.dart';

class Wrapper extends StatefulWidget {

  //Declare ID for named route
  static const String id = '/';

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return user != null
        ? NavigationScreen()
        : WelcomeScreen();

  }
}
