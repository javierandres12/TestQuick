

import 'package:chat/user/repository/auth_api.dart';

class AuthRepository {

  //creamos variable que conecta con auth_api
  final _AuthApi = AuthApi();

  logOutFirebase() => _AuthApi.logOut();

}