
import 'package:chat/user/model/chat.dart';
import 'package:chat/user/model/user.dart';
import 'package:chat/user/repository/auth_repository.dart';
import 'package:chat/user/repository/cloud_firestore_api.dart';
import 'package:chat/user/repository/cloud_firestore_repository.dart';
import 'package:chat/user/repository/firebase_storage_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'dart:io';

class UserBloc implements Bloc{

  final _auth_repository = AuthRepository();

  Stream<FirebaseUser> streamFirebase = FirebaseAuth.instance.onAuthStateChanged;

  //este objeto nos devuelve el estado de la sesion
  Stream<FirebaseUser> get authStatus => streamFirebase;

  //metodo para obtener el currentUser o uid identificador

  Future<FirebaseUser> get currentUser => FirebaseAuth.instance.currentUser();

  //1. metodo de salida
  logOut(){
    _auth_repository.logOutFirebase();
  }

  final _cloudFirestoreRepositoryUser = CloudFirestoreRepositoryUser();

  void updateUserData(User user) =>
      _cloudFirestoreRepositoryUser.updateUserDataRepository(user);

  void updateChat(Chat chat) =>
  _cloudFirestoreRepositoryUser.updateChat(chat);

  Stream<QuerySnapshot> usersListStream =
  Firestore.instance.collection(CloudFirestoreApiUser().USERS).snapshots();

  Stream<QuerySnapshot> get usersStream => usersListStream;

  List<User> buildUser(List<DocumentSnapshot> userListSapshot)=>
      _cloudFirestoreRepositoryUser.buildUser(userListSapshot);

  Stream<QuerySnapshot> chatsListStream =
  Firestore.instance.collection(CloudFirestoreApiUser().CHATS).snapshots();

  Stream<QuerySnapshot> get chatsStream => chatsListStream;

  List<Chat> buildChat(List<DocumentSnapshot> chatListSapshot)=>
  _cloudFirestoreRepositoryUser.buildChat(chatListSapshot);

  Stream<QuerySnapshot> myUser(String uid) =>
      Firestore.instance.collection(CloudFirestoreApiUser().USERS)
          .where('uid', isEqualTo: uid).snapshots();


  //metodo de storage
  final _firebaseStorageRepository = FirebaseStorageRepository();
  Future<StorageUploadTask> upLoadFile(String path, File image ) =>
      _firebaseStorageRepository.uploadFile(path, image);

  @override
  void dispose() {

  }

}