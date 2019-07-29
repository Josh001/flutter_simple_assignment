import 'package:erply_app_assignment/components/rounded_button.dart';
import 'package:erply_app_assignment/constants/app_constants.dart';
import 'package:erply_app_assignment/constants/routes_constants.dart';
import 'package:erply_app_assignment/constants/test_styles.dart';
import 'package:erply_app_assignment/constants/theme.dart';
import 'package:erply_app_assignment/model/api_response.dart';
import 'package:erply_app_assignment/model/user_details_model.dart';
import 'package:erply_app_assignment/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../utility.dart';

class ConfirmLoginPage extends StatefulWidget {
  @override
  _ConfirmLoginPageState createState() => _ConfirmLoginPageState();
}

class _ConfirmLoginPageState extends State<ConfirmLoginPage> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final nameFocus = FocusNode();
  final emailFocus = FocusNode();

  UserDetailsModel userDetailsModel = UserDetailsModel();
  UserService userService = UserService();

  bool isLoading = false;

  Widget renderNameInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(hintText: "Name"),
        textInputAction: TextInputAction.next,
        validator: (value) => value.isEmpty ? "Please provide your name" : null,
        focusNode: emailFocus,
        onFieldSubmitted: (value) =>
            {Utility.changeFocus(context, nameFocus, emailFocus)},
        onSaved: (value) => userDetailsModel.name = value,
      ),
    );
  }

  Widget renderEmailInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        focusNode: emailFocus,
        decoration: InputDecoration(hintText: "Email"),
        validator: (value) => value.isEmpty ? "Email cannot be empty" : null,
        onFieldSubmitted: (value) {
          nameFocus.unfocus();
          sendUserDetails();
        },
        onSaved: (value) => userDetailsModel.email = value,
      ),
    );
  }

  Widget renderButton(String label) {
    return RoundedButton(
      label: label,
      onPressed: () => sendUserDetails(),
      iconData: FontAwesomeIcons.key,
    );
  }

  removeAllFocus() {
    nameFocus.unfocus();
    emailFocus.unfocus();
  }

  toggleLoader(bool loading) {
    setState(() {
      this.isLoading = loading;
    });
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

  void sendUserDetails() async {
    if (Utility.validateForm(formKey)) {
      removeAllFocus();
      toggleLoader(true);

      APIResponse response =
          await this.userService.sendUserDetails(userDetailsModel);
      toggleLoader(false);

      var message = response.isSuccess ? response.message : KGenericError;
      if (!response.isSuccess)
        renderSnackBar(message);
      else
        Navigator.pushReplacementNamed(context, KHomeScreen);
    }
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
                    'confirm current user account',
                    style: kSimpleTextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: renderNameInput(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: renderEmailInput(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: renderButton("Confirm"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
