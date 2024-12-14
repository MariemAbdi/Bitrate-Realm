import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class FirebaseStorageServices{
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(String folder, Uint8List? file ,String fileName) async{
    try{
      if(file!=null){
        String url = await _storage.ref('$folder/$fileName').putData(file).then((p) => p.ref.getDownloadURL());
        return url;
      }
      throw Exception("Please Select A File First.");
    }catch(e){
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String> downloadURL(String folder, String fileName) async{
    return await _storage.ref('$folder/$fileName').getDownloadURL();
  }

  void deleteFile(String folder, String fileName) async{
      await _storage.ref(folder).child(fileName).delete();
  }
}