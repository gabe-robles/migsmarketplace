import 'package:flutter/material.dart';
import 'package:migsmarketplace/components/custom_round_button.dart';
import 'package:migsmarketplace/constants.dart';
import 'package:migsmarketplace/services/cart.dart';

class HomeScreen extends StatefulWidget {

  static const String id = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final CartServices _cart = CartServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Demo Order Creator',
          style: kH3,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            //Customer 1 Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomRoundButton(
                  buttonColor: kMainThemeColor,
                  buttonTitle: 'Customer 1: James Santiago',
                  buttonWidth: 360,
                  onPressed: () async {
                    await _cart.updateOrder(
                      'zSOgiFsYEDj0rx27WwPf',
                      DateTime.now(),
                      'Demo Rider',
                      '+639123456789',
                    );
                  },
                ),
              ],
            ),


            //Customer 2 Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomRoundButton(
                  buttonColor: kMainThemeColor,
                  buttonTitle: 'Customer 2: Eman Diliman',
                  buttonWidth: 360,
                  onPressed: () async {
                    await _cart.updateOrder(
                      'SJ74N3Pf7Rg1jWSrs5q2',
                      DateTime.now(),
                      'Demo Rider',
                      '+639123456789',
                    );
                  },
                ),
              ],
            ),

            //Customer 3 Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomRoundButton(
                  buttonColor: kMainThemeColor,
                  buttonTitle: 'Customer 3: Maria Dela Cruz',
                  buttonWidth: 360,
                  onPressed: () async {
                    await _cart.updateOrder(
                      'ToBxdphPKUpi6aDvFWEa',
                      DateTime.now(),
                      'Demo Rider',
                      '+639123456789',
                    );
                  },
                ),
              ],
            ),

            //Customer 4 Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomRoundButton(
                  buttonColor: kMainThemeColor,
                  buttonTitle: 'Customer 4: Andy Miller',
                  buttonWidth: 360,
                  onPressed: () async {
                    await _cart.updateOrder(
                      'jRnwdKsEclCbfzePmCUz',
                      DateTime.now(),
                      'Demo Rider',
                      '+639123456789',
                    );
                  },
                ),
              ],
            ),

            //Customer 5 Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomRoundButton(
                  buttonColor: kMainThemeColor,
                  buttonTitle: 'Customer 5: Carla Lopez',
                  buttonWidth: 360,
                  onPressed: () async {
                    await _cart.updateOrder(
                      'CO91VMopMMoXiBst2jwp',
                      DateTime.now(),
                      'Demo Rider',
                      '+639123456789',
                    );
                  },
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
