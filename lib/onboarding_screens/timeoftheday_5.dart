import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:concentric_transition/concentric_transition.dart';

class TimeOfTheDayOnboarding5 extends StatelessWidget {
  const TimeOfTheDayOnboarding5({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 150),
              child: ClayContainer(
                color: Colors.black,
                borderRadius: 30,
                depth: 90,
                // spread: 4,
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      child: Image.asset(
                        'assets/images/fridge.jpg',
                        // width: MediaQuery.of(context).size.width * 1.5,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Late Night Cravings? \nWe Got You Covered!"
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Food ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontStyle: FontStyle.italic,
                  ),
                  children: [
                    TextSpan(
                      text: "Recommendations According To ",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: "Time",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: ConcentricClipper(
                progress: 0, // from 0.0 to 1.0
                reverse: false,
                radius: 300.0,
                verticalPosition: 0.75,
              ),
              child: GestureDetector(
                onTap: () {
                  print("det");
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
