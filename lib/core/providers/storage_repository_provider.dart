import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_5/core/failure.dart';
import 'package:project_5/core/providers/firebase_porviders.dart';
import '../type_def.dart';

final storageRepositoryProvider = Provider((ref) =>StorageRepository(firestore: ref.read(storageProvider)));

class StorageRepository{
  final FirebaseStorage _firestore;
  StorageRepository({required FirebaseStorage firestore}):_firestore=firestore;
  FutureEither<String>  storeFile(String path,String id,File? file)async{
    try{
      final ref=_firestore.ref().child(path).child(id);
      UploadTask uploadTask=ref.putFile(file!);
      final snapshot=await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    }catch (e){
      return left(Failure(failure: e.toString()));
    }
  }
}