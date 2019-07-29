import 'package:erply_app_assignment/constants/test_styles.dart';
import 'package:erply_app_assignment/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
//    Navigator.pushNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Icon(
              FontAwesomeIcons.user,
              size: 20.0,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text("Emily", style: kStrongTextStyle),
          ],
        ),
        actions: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Day started 9:12",
                style: kSimpleTextStyleAppBar,
              ),
              Text(
                "Weekly hours 35.2h",
                style: kSimpleTextStyleAppBar,
              ),
            ],
          )
        ],
      ),
      body: Container(
        color: APPLY_GRAY,
        child: Center(
          child: Image.asset(
            'images/clockwht.png',
            height: 280.0,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.settings),
      ),
    );
  }
}
