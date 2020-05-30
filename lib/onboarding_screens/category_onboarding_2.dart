import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';

class CategoryOnboarding2 extends StatelessWidget {
  const CategoryOnboarding2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
              child: ClayContainer(
                color: Colors.redAccent[700],
                borderRadius: 25,
                depth: 60,
                child: ClipRRect(
                  child: Image.asset(
                    'assets/onboarding/category.jpg',
                    // TODO chnage photo luscious
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  borderRadius: BorderRadius.circular(25),
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
                  text: "Luscious ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontStyle: FontStyle.italic,
                  ),
                  children: [
                    TextSpan(
                      text: "Recipes From Various ",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: "Catgories",
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
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          //     child: Text("NEXT"),
          //   ),
          // ),
        ],
      ),
    );
  }
}
