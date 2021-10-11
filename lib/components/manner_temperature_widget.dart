import 'package:flutter/material.dart';

class MannerTemperatureWidget extends StatelessWidget {
  final double mannerTemperature;
  late int level;
  final List<Color> temperColors = const [
    Color(0xff072038),
    Color(0xff0d3a65),
    Color(0xff186ec0),
    Color(0xff37b24d),
    Color(0xffffad13),
    Color(0xfff76707)
  ];

  MannerTemperatureWidget({Key? key, required this.mannerTemperature})
      : super(key: key) {
    _calcTemp();
  }

  void _calcTemp() {
    if (mannerTemperature <= 20) {
      level = 0;
    } else if (mannerTemperature <= 32) {
      level = 1;
    } else if (mannerTemperature <= 36.5) {
      level = 2;
    } else if (mannerTemperature <= 40) {
      level = 3;
    } else if (mannerTemperature <= 50) {
      level = 4;
    } else {
      level = 5;
    }
  }

  Widget _makeTempLabelBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$mannerTemperature℃",
          style: TextStyle(
            color: temperColors[level],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: 60,
            height: 6,
            color: Colors.black.withOpacity(0.2),
            child: Row(
              children: [
                Container(
                  width: 60 / 99 * mannerTemperature,
                  height: 6,
                  color: temperColors[level],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _makeTempLabelBar(),
            Container(
              width: 30,
              height: 30,
              child: Image.asset("assets/images/level-$level.jpg"),
            )
          ],
        ),
        const Text(
          "매너온도",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}
