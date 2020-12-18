

import 'package:chat/user/model/chat.dart';
import 'package:chat/user/model/user.dart';
import 'package:chat/user/repository/cloud_firestore_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreRepositoryUser {
  User user;

  final _cloudFirestoreApi = CloudFirestoreApiUser();

  void updateUserDataRepository(User user) =>
      _cloudFirestoreApi.updateUserData(user);

  void updateChat(Chat chat) =>
  _cloudFirestoreApi.updateChat(chat);

  List<User> buildUser(List<DocumentSnapshot> userListSapshot)=>
      _cloudFirestoreApi.buildUser(userListSapshot);

  List<Chat> buildChat(List<DocumentSnapshot> chatListSapshot)=>
      _cloudFirestoreApi.buildChat(chatListSapshot);


 }