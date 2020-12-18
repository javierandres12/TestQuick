
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardImageChat extends StatelessWidget{


  String image;
  String name;
  final VoidCallback onPressed;

  CardImageChat({Key key,
     this.image,
     this.name,
     this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidht = MediaQuery.of(context).size.width;
    // TODO: implement build

    return InkWell(
        onTap: onPressed,
        child: Container(
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
                child: Text(name,style: TextStyle(fontSize: 20,),),
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
        )
    );

  }
}