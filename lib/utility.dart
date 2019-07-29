import 'package:flutter/cupertino.dart';

class Utility {
  static String encodeMap(Map data) {
    return data.keys
        .map((key) =>
            "${Uri.encodeComponent(key)}=${Uri.encodeComponent(data[key])}")
        .join("&");
  }

  static changeFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static bool validateForm(GlobalKey<FormState> fKey) {
    var form = fKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
