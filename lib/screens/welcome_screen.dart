import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/Roundedbutton.dart';

class WelcomeScreen extends StatefulWidget {
  static const String welcome_id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(
        seconds: 1,
      ),
      vsync: this,
    );
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    // animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    //
    // // AnimationStatus acomplised in case of forward and dismissed in case of reverse so we can use this to make a incresing and decreasing animation in our logo
    // animation.addStatusListener((status) {
    //   if(status==AnimationStatus.completed)
    //     {
    //       controller.reverse(from: 1.0);
    //     }
    //   else  if(status==AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              colour: Colors.lightBlueAccent,
              text: 'Log In',
              onpressedName: () {
                Navigator.pushNamed(context, LoginScreen.login_id);
              },
            ),
            RoundedButton(
              colour: Colors.blueAccent,
              text: 'Register',
              onpressedName: () {
                Navigator.pushNamed(
                    context, RegistrationScreen.registration_id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
