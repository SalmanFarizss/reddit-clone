import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_5/core/constants/constants.dart';
import 'package:project_5/core/constants/firebase_constants.dart';
import 'package:project_5/core/failure.dart';
import 'package:project_5/core/providers/firebase_porviders.dart';
import 'package:project_5/core/type_def.dart';
import 'package:project_5/models/user_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firestore: ref.read(fireStoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider)));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  AuthRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;
  CollectionReference get _users=>_firestore.collection(FirebaseConstants.usersCollection);
  Stream<User?> get authStateChange=>_auth.authStateChanges();
  FutureEither<UserModel> signInWithGoogle() async {
    UserModel userModel;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User user=userCredential.user!;
      if(userCredential.additionalUserInfo!.isNewUser){
        userModel = UserModel(
         name: user.displayName ?? 'No name',
         profile: user.photoURL ?? Constants.avatarDefault,
         banner: Constants.bannerDefault,
         uid: user.uid,
         isGuest: true,
         karma: 0,
         awards: [],
       );
       await _users.doc(user.uid).set(userModel.toMap());
     }else{
        userModel=await getUser(user.uid).first;
      }
     return right(userModel);
    } on FirebaseException catch(e) {
      throw e.message!;
    }
    catch(e){
      return left(Failure(failure: e.toString()));
    }
  }
  Stream<UserModel> getUser(String uid){
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String,dynamic>));
  }
  void signOut(){
    _googleSignIn.signOut();
    _auth.signOut();
  }
}
