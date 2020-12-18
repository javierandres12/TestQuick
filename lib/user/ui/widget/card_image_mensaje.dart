
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardImageMensaje extends StatelessWidget{


  String image;
  String urlImage;
  String name;
  String fecha;
  String mensaje;
  int index;


  CardImageMensaje({Key key,
     this.image,
     this.name,
     this.urlImage,
     this.fecha,
     this.mensaje,
     this.index
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidht = MediaQuery.of(context).size.width;
    // TODO: implement build

    final Imagen = new Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(left: 5)),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10.0)
            ),
          ),
          Padding(padding: EdgeInsets.all(6)),
          Container(
              margin: EdgeInsets.all(3),
              child: Column(
                children: [
                  Text(name,style: TextStyle(fontSize: 12,),),
                  Text(fecha,style: TextStyle(fontSize: 12,),),
                  //Text(mensaje,style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                  Padding(padding: EdgeInsets.only(bottom: 3)),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(urlImage),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                  ),

                ],
              )
          )
        ],
      ),
      width: screenWidht-30,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: EdgeInsets.only(top: 5,left: 5,right: 5),
      //padding: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
    );

    final Texto = new Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(left: 5)),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10.0)
            ),
          ),
          Padding(padding: EdgeInsets.all(6)),
          Container(
              margin: EdgeInsets.all(5),
              child: Column(
                children: [
                  Text(name,style: TextStyle(fontSize: 12,),),
                  Text(fecha,style: TextStyle(fontSize: 12,),),
                  Text(mensaje,style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                ],
              )
          )
        ],
      ),
      width: screenWidht-30,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: EdgeInsets.only(top: 5,left: 5,right: 5),
      //padding: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
    );

    if(index==0){
      return Imagen;
    }else{
      return Texto;
    }

  }
}