
import 'package:chat/user/bloc/bloc_user.dart';
import 'package:chat/user/ui/screen/register_page.dart';
import 'package:chat/user/ui/screen/settings_screen.dart';
import 'package:chat/user/ui/screen/splash_screen.dart';
import 'package:chat/user/ui/widget/list_view_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';


class ChatHome extends StatefulWidget{
  String uid;

  ChatHome({
    this.uid
});

  @override
  State<StatefulWidget> createState() {
    return _ChatHome();
  }
}

class _ChatHome extends State<ChatHome>{
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);


    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios TestQuick', style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
              icon: Icon(Icons.settings, color: Colors.white,),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder:(context)=>SettingsScreen(uid: widget.uid,)));
              }),
          IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.white,),
              onPressed: (){
                userBloc.logOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RegisterPage() ));
              })
        ],
      ),
      body: ListView(
        children: [
          ListViewUsers(uid: widget.uid,)
        ],
      ),
    );

  }
}