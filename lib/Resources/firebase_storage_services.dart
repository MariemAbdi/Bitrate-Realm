import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class Storage{
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadFile(String folder, Uint8List file ,String fileName) async{
    try{
      await _storage.ref('$folder/$fileName').putData(file);
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<String> downloadURL(String folder, String fileName) async{
    return await _storage.ref('$folder/$fileName').getDownloadURL();
  }

  void deleteFile(String folder, String fileName) async{
      await _storage.ref(folder).child(fileName).delete();
  }
}