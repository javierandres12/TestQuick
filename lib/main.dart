import 'package:chat/chat_home.dart';
import 'package:chat/user/bloc/bloc_user.dart';
import 'package:chat/user/ui/screen/register_page.dart';
import 'package:chat/user/ui/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        child: MaterialApp(

          title: 'ChatApp',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Color(0xFF2EBFF7),
            accentColor: Colors.blueAccent,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SplashScreen(),
        ),
        bloc: UserBloc()
    );
  }
}


