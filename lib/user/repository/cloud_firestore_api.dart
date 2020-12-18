
import 'package:chat/user/model/chat.dart';
import 'package:chat/user/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class CloudFirestoreApiUser{
  final String USERS = "users";
  final String CHATS = "chats";

  //creamos el tipo de firestore llamado _db y luego instanciamos

  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateUserData(User user) async{
    //insertar la collection de USERS a la _db
    DocumentReference reference = _db.collection(USERS).document(user.uid);
    return await reference.setData({
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
      'image':user.image,
      'lastSignIn': DateTime.now()
    }, merge: true);
  }

  void updateChat(Chat chat) async {
    DocumentReference reference = _db.collection(CHATS).document('${chat.grupo}');
    return await reference.setData({
      'mensaje': chat.mensaje,
      'grupo': chat.grupo,
      'fecha': chat.fecha,
      'name':chat.name,
      'urlImage':chat.urlImage,
      'index':chat.index,
      'image':chat.image
    });
  }

  List<User> buildUser(List<DocumentSnapshot> userListSapshot){
    List<User> users = List<User>();
    userListSapshot.forEach((p) {
      User user = User(
          uid: p.data['uid'],
          name: p.data['name'],
          email: p.data['email'],
          image: p.data['image']);
      users.add(user);
    });
    return users;
  }

  List<Chat> buildChat(List<DocumentSnapshot> chatListSapshot){
    List<Chat> chats = List<Chat>();
    chatListSapshot.forEach((p) {
      Chat chat = Chat(
          grupo: p.data['grupo'],
          name: p.data['name'],
          image: p.data['image'],
          index: p.data['index'],
          urlImage: p.data['urlImage'],
          mensaje: p.data['mensaje'],
          fecha: p.data['fecha']);
      chats.add(chat);
    });
    return chats;
  }



}