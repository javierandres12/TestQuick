import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageAPI{
// con esto se genera la referencia y asi el url por el cual enviaremos la informacion
  final StorageReference _storageReference = FirebaseStorage.instance.ref();
  //se encarga de la subida del archivo


  Future<StorageUploadTask> uploadFile(String path,File image) async{
    StorageUploadTask storageUploadTask =
    _storageReference.child(path).putFile(image);
    return storageUploadTask;

  }
}