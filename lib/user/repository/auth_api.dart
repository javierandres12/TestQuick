

import 'package:firebase_auth/firebase_auth.dart';

class AuthApi{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //metodo para salir cerrar sesión
  logOut() async {
    await _auth.signOut();
  }

}