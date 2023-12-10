import 'package:flutter/material.dart';
import '../constants/colors.dart';

// ignore: must_be_immutable
class HeaderContainer extends StatelessWidget {
  var text = "Login";

  HeaderContainer(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [tdDarkBlue, tdBlue],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(100))),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 10,
            right: MediaQuery.of(context).size.width / 2 -
                75, // Setengah dari lebar layar minus setengah panjang teks
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
          ),
          Center(
            child: Image.asset("assets/images/logo.png"),
          ),
        ],
      ),
    );
  }
}
