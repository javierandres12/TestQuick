

import 'package:chat/chat_home.dart';
import 'package:chat/user/bloc/bloc_user.dart';
import 'package:chat/user/model/user.dart';
import 'package:chat/user/ui/widget/button_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class RegisterPage extends StatefulWidget{



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage>{


  UserBloc userBloc;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  // variable para el key que permite acceder al formulario actual del codigo
  final _formkey =  GlobalKey<FormState>();
  // creamos las variables para guardar los datos


  String _email;
  String _password;
  bool _isRegistering = false;
  bool _isLogin = false;

  int color1= 0xFF2EBFF7;

  _register() async{

    if(_isRegistering)return;
    setState(() {
      _isRegistering = true;
    });

    // guardamos en una variable llamada form para dar una referencia de state
    // y llamar a los metodos validar y guardar del Form
    final form = _formkey.currentState;

    if(!form.validate()){
      //Intearctuamos para decir que esta mal
      _scaffoldkey.currentState.hideCurrentSnackBar();

      //En caso de que el form este mal setiamos el valor de _isRegistering
      setState(() {
        _isRegistering= false;
      });
      return;
    }

    form.save();

    try {

      final FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email, password: _password)).user;
      _scaffoldkey.currentState.showSnackBar(
          SnackBar(
            content:Text('Registrando usuario'),
          ));

      await user.sendEmailVerification();
      _scaffoldkey.currentState.showSnackBar(
          SnackBar(
            content:Text('Enviado correo de verificacion, por favor verifique su cuenta'),
          ));



    }catch(e){
      _scaffoldkey.currentState.hideCurrentSnackBar();
      _scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text(e.message),
        duration: Duration(seconds: 10),
        action: SnackBarAction(
            label: 'Error',
            onPressed: (){
              _scaffoldkey.currentState.hideCurrentSnackBar();
            }
        ),
      ));
    } finally{
      setState(() {
        _isRegistering = false;
      });

    }


  }

  _login() async{

    if(_isLogin)return;
    setState(() {
      _isLogin = true;
    });

    //Interactuamos con el ususario con un SnackBar


    // guardamos en una variable llamada form para dar una referencia de state
    // y llamar a los metodos validar y guardar del Form
    final form = _formkey.currentState;

    if(!form.validate()){
      //Intearctuamos para decir que esta mal
      _scaffoldkey.currentState.hideCurrentSnackBar();

      //En caso de que el form este mal setiamos el valor de _isLogin
      setState(() {
        _isLogin= false;
      });
      return;
    }

    form.save();

    try {

      FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email,password: _password)).user;
      if(user.isEmailVerified) {
        userBloc.myUser(user.uid).listen((p) {
          if (p.documents.isEmpty) {
            userBloc.updateUserData(User(
              uid: user.uid,
              name: user.email,
              image: 'https://thumbs.dreamstime.com/b/icono-de-la-cuenta-de-usuario-ejemplo-s%C3%B3lido-del-logotipo-de-la-persona-pictog-90235639.jpg',
              email: user.email,
            ));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ChatHome(uid: user.uid,)) );
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ChatHome(uid: user.uid,)) );
          }
        });
      }else{
        _scaffoldkey.currentState.showSnackBar(
            SnackBar(
              content:Text('Por favor verifique el usuario'),
            ));
      }

    }catch(e){
      _scaffoldkey.currentState.hideCurrentSnackBar();
      _scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text(e.message),
        duration: Duration(seconds: 10),
        action: SnackBarAction(
            label: 'Error',
            onPressed: (){
              _scaffoldkey.currentState.hideCurrentSnackBar();
            }
        ),
      ));
    } finally{
      setState(() {
        _isLogin = false;
      });

    }


  }

  @override
  Widget build(BuildContext context) {
    //variables para el largo y ancho de la pantalla

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidht = MediaQuery.of(context).size.width;
    userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      key: _scaffoldkey,
      body: new Container(
          child: Form(
              key: _formkey,
              child: Container(
                margin: EdgeInsets.only(left: 2, right: 2,bottom: 2),
                child: ListView(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("icons/chat.png"),
                                )
                            ),
                            height: 250,
                            width: screenWidht,
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            padding: EdgeInsets.only(bottom: 5),
                            child:  Text('Registra tu cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                          ),
                        ],
                      ),
                      height: 300,
                      width: screenWidht,
                      color: Color(color1),
                      padding: EdgeInsets.only(top: 5),
                    ),
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                      ),
                      validator: (val){
                        if(val.isEmpty){
                          return 'Por favor ingrese su correo electrónico';
                        }else{
                          return null;
                        }
                      },
                      onSaved: (val){
                        setState(() {
                          _email=val;
                        });
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      validator: (val){
                        if(val.isEmpty){
                          return 'Por favor ingrese la contraseña';
                        }else{
                          return null;
                        }
                      },
                      onSaved: (val){
                        setState(() {
                          _password=val;
                        });
                      },
                    ),
                    Padding(padding: EdgeInsets.only(top: screenHeight/70)),
                    ButtonLogin(
                      buttonText: 'Registrar Cuenta',
                      onPressed: (){
                        _register();
                      },
                      color1: color1,
                      iconData: Icons.email,
                    ),

                    ButtonLogin(
                      buttonText: 'Ingresa con tu Cuenta',
                      onPressed: (){
                        _login();
                      },
                      color1: color1,
                      iconData: Icons.account_circle,
                    ),
                  ],
                ),
              )

          ),

      ),
    );
  }
}