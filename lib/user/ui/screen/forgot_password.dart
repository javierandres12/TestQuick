
import 'package:chat/user/bloc/bloc_user.dart';
import 'package:chat/user/ui/screen/register_page.dart';
import 'package:chat/user/ui/widget/button_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class ForgotPassword extends StatefulWidget{



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ForgotPassword();
  }
}

class _ForgotPassword extends State<ForgotPassword>{


  final _scaffoldkey = GlobalKey<ScaffoldState>();
  // variable para el key que permite acceder al formulario actual del codigo
  final _formkey =  GlobalKey<FormState>();

  bool _isForgotPassword = false;
  String _email;
  int color1= 0xFF2EBFF7;
  //metodo Login
  _forgotPassword() async{

    if(_isForgotPassword)return;
    setState(() {
      _isForgotPassword = true;
    });

    //Interactuamos con el ususario con un SnackBar
    _scaffoldkey.currentState.showSnackBar(
        SnackBar(
          content:Text('Por favor revise su correo electronico, enviamos un email para restablecer su contraseña'),
        ));

    // guardamos en una variable llamada form para dar una referencia de state
    // y llamar a los metodos validar y guardar del Form
    final form = _formkey.currentState;

    if(!form.validate()){
      //Intearctuamos para decir que esta mal
      _scaffoldkey.currentState.hideCurrentSnackBar();

      //En caso de que el form este mal setiamos el valor de _isLogin
      setState(() {
        _isForgotPassword= false;
      });
      return;
    }

    form.save();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
      _scaffoldkey.currentState.hideCurrentSnackBar();
      _scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text('Por favor revise su correo electronico, enviamos un email para restablecer su contraseña'),
        duration: Duration(seconds: 10),
      ));
      return RegisterPage();
      //Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage() ));


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
        _isForgotPassword = false;
      });

    }


  }
  UserBloc userBloc;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidht = MediaQuery.of(context).size.width;
    userBloc = BlocProvider.of<UserBloc>(context);



    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 150,
          bottom: PreferredSize(child:
          Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: screenWidht/7),
                    child: Icon(Icons.vpn_key,size: 100,color: Colors.white,),
                  ),
                  Padding(padding: EdgeInsets.only(right: 5)),
                  Text('TestQuick', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),),
                ],
              ),
              Text('Ingresa tu correo eletrónico', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
              Padding(padding: EdgeInsets.only(bottom: 2),)
            ],
          ),
              preferredSize: Size(screenWidht, screenHeight/3)
          ),
          backgroundColor: Color(color1),
        ),
        key: _scaffoldkey,
        body: Container(
              child: Form(
                  key: _formkey,
                  child: Container(
                    child: ListView(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 5)),
                        TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                          ),
                          validator: (val){
                            if(val.isEmpty){
                              return 'Por favor ingrese su correo electronico';
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
                        ButtonLogin(
                          buttonText: 'Recuperar contraseña',
                          onPressed: (){
                            _forgotPassword();
                          },
                          color1: color1,
                          color2: color1,
                          iconData: Icons.restore,
                        ),

                      ],

                    ),
                  )
              )

        ),


    );



  }
}