import 'package:flutter/material.dart';

class Chat{
  final String grupo;
  final String mensaje;
  final String fecha;
  final String name;
  final String image;
  final int index;
  final String urlImage;


  Chat({Key key,
    @required this.grupo,
    @required this.mensaje,
    @required this.fecha,
    @required this.image,
    @required this.name,
    @required this.urlImage,
    @required this.index
  });

}