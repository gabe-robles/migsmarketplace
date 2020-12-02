import 'package:migsmarketplace/components/custom_round_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:migsmarketplace/services/auth.dart';
import 'package:migsmarketplace/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  //Declare id for named routes
  static const String id = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Initiate Variables
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textEmail = TextEditingController();
  TextEditingController _textPassword = TextEditingController();

  //Declare services as variable
  final AuthService _auth = AuthService();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //Dispose of controllers after login
    _textEmail.dispose();
    _textPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, auth, _) {
      return ModalProgressHUD(
        inAsyncCall: auth.showSpinner,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Log In', style: kH3),
          ),
          body: GestureDetector(
            //Hide Keyboard when tapping anywhere else
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    //Logo
                    Flexible(
                      child: Hero(
                        tag: 'logo',
                        child: Container(
                          height: 128.0,
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                              'assets/images/icon.jpg'),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 28.0,
                    ),

                    //Phone Number Field
                    TextFormField(
                      controller: _textEmail,
                      keyboardType: TextInputType.emailAddress,
                      style: kH3,
                      decoration: kTextFieldDecoration.copyWith(
                        icon: Icon(Icons.email, size: 36),
                        labelText: 'Email',
                        hintText: 'e.g. juan@email.com',
                      ),
                      validator: (value) {
                        if (value.length < 10) {
                          return 'Invalid Email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                      height: 12.0,
                    ),

                    //Password Field
                    TextFormField(
                      controller: _textPassword,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      style: kH3,
                      decoration: kTextFieldDecoration.copyWith(
                        icon: Icon(
                          Icons.lock,
                          size: 36,
                        ),
                        labelText: 'Password',
                        hintText: 'Enter Password',
                      ),
                      validator: (value) {
                        if (value.length < 5) {
                          return 'Invalid Password';
                        }

                        return null;
                      },
                    ),

                    SizedBox(
                      height: 24.0,
                    ),

                    //Login Button
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: CustomRoundButton(
                          buttonTitle: "Log In",
                          buttonColor: kMainThemeColor,
                          buttonWidth: 200.0,
                          onPressed: () async {
                            final form = _formKey.currentState;
                            if (form.validate()) {
                              // Text forms was validated.
                              form.save();
                            }
                            await _auth.logIn(
                              context: _scaffoldKey.currentContext,
                              email: _textEmail.text,
                              password: _textPassword.text,
                            );
                          } // onPressed
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  } // build

} // _LoginScreenState
