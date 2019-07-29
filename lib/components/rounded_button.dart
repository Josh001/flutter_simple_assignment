import 'package:erply_app_assignment/constants/theme.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final IconData iconData;

  RoundedButton({this.label, this.onPressed, this.iconData});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(20.0),
      onPressed: onPressed,
      color: APPLY_BLUE,
      shape: OutlineInputBorder(
        borderSide: BorderSide(
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 10.0,
          ),
          Icon(
            iconData,
            color: Colors.white,
            size: 15.0,
          )
        ],
      ),
    );
  }
}
