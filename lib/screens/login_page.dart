import 'package:erply_app_assignment/components/rounded_button.dart';
import 'package:erply_app_assignment/constants/routes_constants.dart';
import 'package:erply_app_assignment/constants/test_styles.dart';
import 'package:erply_app_assignment/constants/theme.dart';
import 'package:erply_app_assignment/model/auth_response_model.dart';
import 'package:erply_app_assignment/model/user_login_model.dart';
import 'package:erply_app_assignment/service/auth_service.dart';
import 'package:erply_app_assignment/utility.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  bool isLoading = false;

  UserLoginModel userModel = UserLoginModel();

  AuthService authService = AuthService();

  Widget renderEmailInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(hintText: "E-mail"),
        textInputAction: TextInputAction.next,
        validator: (value) =>
            value.isEmpty ? "Please provide your email" : null,
        focusNode: emailFocus,
        onFieldSubmitted: (value) =>
            {Utility.changeFocus(context, emailFocus, passwordFocus)},
        onSaved: (value) => userModel.userEmail = value,
      ),
    );
  }

  Widget renderPasswordInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: true,
        focusNode: passwordFocus,
        decoration: InputDecoration(hintText: "Password"),
        validator: (value) => value.isEmpty ? "Password cannot be empty" : null,
        onFieldSubmitted: (value) {
          passwordFocus.unfocus();
          userLogin();
        },
        onSaved: (value) => userModel.password = value,
      ),
    );
  }

  Widget renderButton(String label) {
    return RoundedButton(
      label: label,
      onPressed: () => this.userLogin(),
      iconData: FontAwesomeIcons.key,
    );
  }

  toggleLoader(bool loading) {
    setState(() {
      this.isLoading = loading;
    });
  }

  removeAllFocus() {
    passwordFocus.unfocus();
    emailFocus.unfocus();
  }

  void userLogin() async {
    if (Utility.validateForm(formKey)) {
      removeAllFocus();
      toggleLoader(true);
      AuthResponseModel response =
          await this.authService.authenticateUser(userModel);
      toggleLoader(false);
      if (!response.isSuccess)
        renderSnackBar(response.errorMessage);
      else {
        authService.persistJwtToken(response.jwtToken);
        Navigator.pushReplacementNamed(context, KConfirmScreen);
      }
    }
  }

  dynamic renderSnackBar(String errorMessage) {
    return this._scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: new Text(
              'Error: $errorMessage',
              style: kErrorTextStyle,
            ),
            backgroundColor: Colors.white,
            duration: new Duration(seconds: 5),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: APPLY_YELLOW,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(30.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset("images/reception.png"),
                  Text(
                    'Login with your manager account',
                    style: kSimpleTextStyle,
                  ),
                  renderEmailInput(),
                  renderPasswordInput(),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: renderButton("Log-in"),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () => userLogin(),
                        child: Text(
                          "Forgot account details ?",
                          style: kSimpleTextStyleLoginLabel,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
