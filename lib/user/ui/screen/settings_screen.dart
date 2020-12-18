

import 'package:chat/user/bloc/bloc_user.dart';
import 'package:chat/user/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class SettingsScreen extends StatefulWidget{
  String uid;


  SettingsScreen({
    this.uid
});

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreen();
  }
}

class _SettingsScreen extends State<SettingsScreen>{
  List<DocumentSnapshot> lista =[];
  int color1 = 0xFF2EBFF7;
  UserBloc userBloc;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  // variable para el key que permite acceder al formulario actual del codigo
  final _formkey =  GlobalKey<FormState>();
  String _name;
  File image;
  bool _isSend = false;

  Future _sendData() async{

    if(_isSend)return;
    setState(() {
      _isSend = true;
    });

    final form = _formkey.currentState;

    if(!form.validate()){
      _scaffoldkey.currentState.hideCurrentSnackBar();
      setState(() {
        _isSend= false;
      });
      return;
    }
    form.save();
    userBloc.currentUser.then((FirebaseUser user){
      if(_name!=null){
        _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('Se registraron tus datos')));
        userBloc.updateUserData(User(
            uid: user.uid,
            name: _name,
            image: lista[0].data['image'],
            email: user.email,
        ));
        Navigator.pop(context);
      }else{
        _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('No se registraron tus datos, por favor intenta de nuevo')));
      }
    });

  }

  Future getImage() async{
    PickedFile pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    image = File(pickedFile.path);
    userBloc.currentUser.then((FirebaseUser user){
      String path = "${user.uid}/${DateTime.now().toString()}.jpg";
      _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('Cargando imagen en la base de datos')));
      userBloc.upLoadFile(path, image)
          .then((StorageUploadTask storageUploadTask){
        storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot) {
          _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('Realizando el cambio de imagen')));
          snapshot.ref.getDownloadURL().then((urlImage){
            userBloc.updateUserData(
                User(
                    uid: user.uid,
                    name: lista[0].data['name'],
                    email: user.email,
                    image: urlImage.toString()
                ));
          });
        });
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidht = MediaQuery.of(context).size.width;
    userBloc = BlocProvider.of<UserBloc>(context);


    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: StreamBuilder(
        stream: userBloc.myUser(widget.uid),
          builder: (BuildContext context, AsyncSnapshot snapshot){
          if(!snapshot.hasData || snapshot.hasError){
            return Center(
              child: Container(
                height: 70,
                width: 70,
                child: CircularProgressIndicator(),
              ),
            );
          }else{
            lista = snapshot.data.documents;

            return Center(
              child: ListView(
                children: [
                  Container(
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(lista[0].data['image']),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 5)),
                          Container(
                              height: 50,
                              width: 50,
                              child: FloatingActionButton(
                                onPressed: getImage,
                                child: Icon(Icons.camera_alt),
                              )
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 5)),
                          Container(
                            child: TextFormField(
                              autocorrect: false,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: lista[0].data['name'],
                              ),
                              validator: (val){
                                if(val.isEmpty){
                                  return 'Por favor ingrese su nombre';
                                }else{
                                  return null;
                                }
                              },
                              onSaved: (val){
                                setState(() {
                                  _name=val;
                                });
                              },
                            ),
                            margin: EdgeInsets.all(5),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 5)),
                          InkWell(
                            onTap: (){
                              _sendData();
                            },
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Color(color1),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Text('Actualizar nombre', style: TextStyle(color: Colors.white, fontSize: 15),),
                            ),
                          )
                        ],
                      ),
                    ),
                    width: screenWidht-30,
                    height: 450,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: EdgeInsets.only(top: 5,left: 5,right: 5),
                    //padding: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            );
          }
          })
    );

  }
}