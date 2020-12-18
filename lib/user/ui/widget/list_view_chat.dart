
import 'package:chat/user/bloc/bloc_user.dart';
import 'package:chat/user/model/chat.dart';
import 'package:chat/user/model/user.dart';
import 'package:chat/user/ui/screen/chat_screen.dart';
import 'package:chat/user/ui/widget/card_image_chat.dart';
import 'package:chat/user/ui/widget/card_image_mensaje.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class ListViewChat extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    return _ListViewChat();
  }
}

class _ListViewChat extends State<ListViewChat> {
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);

    return StreamBuilder(
        stream: userBloc.chatsStream,
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return View(
                  userBloc.buildChat(snapshot.data.documents));
            case ConnectionState.done:
              return View(
                  userBloc.buildChat(snapshot.data.documents));
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.none:
              return CircularProgressIndicator();
            default:
              return View(
                  userBloc.buildChat(snapshot.data.documents));
          }
        }
    );

  }
  Widget View(List<Chat> chats){
    return Column(
      children: chats.map((chat){
        return CardImageMensaje(
          image: chat.image,
          urlImage: chat.urlImage,
          index: chat.index,
          name: chat.name,
          fecha: chat.fecha,
          mensaje: chat.mensaje,
        );
      }).toList(),
    );
  }

}