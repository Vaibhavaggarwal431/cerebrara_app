import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2),()
    {
      Navigator.pushReplacementNamed(context, "/home",);
    }
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            Text("Celebrara ",style: TextStyle(fontSize: 36,fontWeight: FontWeight.w400,color: Colors.black,fontFamily: "Mulish"),),
            SizedBox(height: 2,),

          ],
        ),
      ),

      backgroundColor: Colors.white,
    );
  }
}
