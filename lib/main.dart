import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:migsmarketplace/constants.dart';
import 'package:migsmarketplace/models/user.dart';
import 'package:migsmarketplace/services/auth.dart';
import 'package:migsmarketplace/services/database.dart';
import 'package:migsmarketplace/screens/wrapper.dart';
import 'package:migsmarketplace/screens/home.dart';
import 'package:migsmarketplace/screens/welcome.dart';
import 'package:migsmarketplace/screens/login.dart';
import 'package:migsmarketplace/screens/register.dart';
import 'package:migsmarketplace/screens/account.dart';
import 'package:migsmarketplace/screens/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
        ChangeNotifierProvider<AuthService>(create: (context)=> AuthService(), lazy: false),
        ProxyProvider<User, DatabaseService>(update: (_, user, __) => DatabaseService(uid: user?.uid)),
      ],
      child: MigsMarketplace(),
    ),
  );
}

class MigsMarketplace extends StatefulWidget {

  @override
  _MigsMarketplaceState createState() => _MigsMarketplaceState();
}

class _MigsMarketplaceState extends State<MigsMarketplace> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //Disable Landscape Mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Migs Merchant',
      theme: ThemeData(
        fontFamily: 'Biryani',
        primaryColor: kMainThemeColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        Wrapper.id: (context)=> Wrapper(),
        WelcomeScreen.id: (context)=> WelcomeScreen(),
        RegisterScreen.id: (context)=> RegisterScreen(),
        LoginScreen.id: (context)=> LoginScreen(),
        NavigationScreen.id: (context)=> NavigationScreen(),
        HomeScreen.id: (context)=> HomeScreen(),
        AccountScreen.id: (context)=> AccountScreen(),
      },
      initialRoute: Wrapper.id,
    );
  }
}

//Flutter 1.22.4