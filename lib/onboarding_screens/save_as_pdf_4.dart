import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';

class SaveAsPdfOnboarding4 extends StatelessWidget {
  const SaveAsPdfOnboarding4({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              child: ClayContainer(
                borderRadius: 30,
                depth: 60,
                color: Color(0xffff2e63),
                child: ClipRRect(
                  child: Image.asset(
                    'assets/onboarding/saveaspdf.jpg',
                    // TODO change image direcyons too big
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  borderRadius: BorderRadius.circular(30),
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
                  text: "Save And Share ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontStyle: FontStyle.italic,
                  ),
                  children: [
                    TextSpan(
                      text: "The Recipe As ",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: "PDF",
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
        ],
      ),
    );
  }
}
