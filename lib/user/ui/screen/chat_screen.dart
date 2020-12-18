
import 'dart:io';
import 'package:chat/user/bloc/bloc_user.dart';
import 'package:chat/user/model/chat.dart';
import 'package:chat/user/ui/widget/list_view_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget{

  String uid;

  ChatScreen({
    this.uid
});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChatScreen();
  }
}

class _ChatScreen extends State<ChatScreen>{
  int color1= 0xFF2EBFF7;
  List<DocumentSnapshot> lista;
  File image;
  UserBloc userBloc;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  // variable para el key que permite acceder al formulario actual del codigo
  final _formkey =  GlobalKey<FormState>();
  // creamos las variables para guardar los datos
  String _mensaje;
  bool _isSend = false;

  Future _enviar() async{

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
      if(_mensaje!=null){
        print(_mensaje);
        userBloc.updateChat(
            Chat(
                grupo: '${'grupoTestQuick'}\ ${DateTime.now()}',
                image: lista[0].data['image'],
                index: 1,//texto 1, imagen 0
                urlImage: 'sin imagen',
                name: lista[0].data['name'],
                mensaje: _mensaje,
                fecha: DateTime.now().toIso8601String()
            ));
        _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('Enviando mensaje'),duration: Duration(milliseconds: 3),));
        _formkey.currentState.reset();
        _isSend= false;
      }else{
        _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('No se envio tu mensaje')));
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
            print('vamos aca');
        storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot) {
          print('vamos aca');
          snapshot.ref.getDownloadURL().then((urlImage){
            print(urlImage);
            _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('Enviando mensaje')));
            userBloc.updateChat(
                Chat(
                    grupo: '${'grupoTestQuick'}\ ${DateTime.now()}',
                    image: lista[0].data['image'],
                    index: 0,//texto 1, imagen 0
                    urlImage: urlImage,
                    name: lista[0].data['name'],
                    mensaje: '',
                    fecha: DateTime.now().toIso8601String()
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


    return StreamBuilder(
      stream: userBloc.myUser(widget.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData || snapshot.hasError){
          return CircularProgressIndicator();
        }else{

          lista = snapshot.data.documents;
          return Scaffold(
              appBar: AppBar(
                title: Text('Chat', style: TextStyle(color: Colors.white),),
              ),
              key: _scaffoldkey,
              body: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Flex(direction: Axis.horizontal,
                          children: [
                            Expanded(child: SizedBox(
                                height: screenHeight-140,
                                width: screenWidht,
                                child: ListView(
                                  children: [
                                    ListViewChat()
                                  ],
                                )
                            )),
                          ],),
                        Row(
                          children: [
                            Container(
                              child: TextFormField(

                                decoration: InputDecoration(
                                  hintText: 'Escribe un mensaje',
                                  prefixIcon: IconButton(icon: Icon(Icons.camera_alt), onPressed: (){
                                    getImage();
                                    print('icono');}
                                  ),
                                  suffixIcon: IconButton(icon: Icon(Icons.send), onPressed: (){
                                    _enviar();
                                    print('enviar');
                                  }),
                                ),
                                validator: (val){
                                  if(val.isEmpty){
                                    return 'Por favor ingrese un mensaje';
                                  }else{
                                    return null;
                                  }
                                },
                                onSaved: (val){
                                  setState(() {
                                    _mensaje=val;
                                  });
                                },
                              ),
                              width: screenWidht-60,
                            ),
                            Container(
                              child: FloatingActionButton(
                                  backgroundColor: Color(color1),
                                  child: Icon(Icons.mic),
                                  onPressed:(){
                                    print('audio');
                                  }),
                              height: 40,
                              width: 40,
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 3))
                      ],
                    ),
                  )
              )
          );
        }
        });
  }
}

