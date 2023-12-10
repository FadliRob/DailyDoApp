import 'package:flutter/material.dart';
import '../constants/colors.dart';

// ignore: must_be_immutable
class RegisterContainer extends StatelessWidget {
  var text = "Register";

  RegisterContainer(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
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
                70, // Setengah dari lebar layar minus setengah panjang teks
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
          Center(
            child: Image.asset(
              "assets/images/logo.png",
              width: 100,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
