import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final String title;
  final String number;
  final Color textColor;
  final Color borderColor;

  const InfoBox({
    Key? key,
    required this.title,
    required this.number,
    this.textColor = Colors.black,
    this.borderColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width / 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            number,
            style: TextStyle(
              color: textColor,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
