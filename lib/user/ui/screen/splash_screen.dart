import 'package:chat/user/ui/screen/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();

  }
}

class _SplashScreen extends State<SplashScreen>{
  int color1 = 0xFF2EBFF7;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2),
        (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RegisterPage() ));
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidht = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            width: screenWidht,
            decoration: BoxDecoration(
              color: Color(color1),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: (screenHeight/2)-100),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("icons/chat.png"),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Text('TestQuick S.A.S', style: TextStyle(color: Colors.white,fontSize: 25),)
              ],
            ),
          )
        ],
      )
    );

  }
}