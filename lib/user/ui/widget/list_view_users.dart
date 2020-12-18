
import 'package:chat/user/bloc/bloc_user.dart';
import 'package:chat/user/model/user.dart';
import 'package:chat/user/ui/screen/chat_screen.dart';
import 'package:chat/user/ui/widget/card_image_chat.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class ListViewUsers extends StatefulWidget{
  String uid;
  ListViewUsers({
    this.uid
});


  @override
  State<StatefulWidget> createState() {
    return _ListViewUsers();
  }
}

class _ListViewUsers extends State<ListViewUsers> {
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);

    return StreamBuilder(
        stream: userBloc.usersStream,
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return View(
                  userBloc.buildUser(snapshot.data.documents));
            case ConnectionState.done:
              return View(
                  userBloc.buildUser(snapshot.data.documents));
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.none:
              return CircularProgressIndicator();
            default:
              return View(
                  userBloc.buildUser(snapshot.data.documents));
          }
        }
    );

  }
  Widget View(List<User> users){
    return Column(
      children: users.map((user){
        return CardImageChat(
            image: user.image,
            name: user.name,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(uid: widget.uid,)));
            }
        );
      }).toList(),
    );
  }

}