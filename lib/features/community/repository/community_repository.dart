import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_5/core/constants/firebase_constants.dart';
import 'package:project_5/core/failure.dart';
import 'package:project_5/core/providers/firebase_porviders.dart';
import 'package:project_5/core/type_def.dart';
import 'package:project_5/models/community_models.dart';

final communityRepositoryProvider = Provider(
    (ref) => CommunityRepository(firestore: ref.read(fireStoreProvider)));

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  FutureVoid createCommunity(CommunityModel communityModel) async {
    try {
      var communityDoc = await _communities.doc(communityModel.name).get();
      if (communityDoc.exists) {
        throw 'Community with the same name already exists!';
      }
      return right(
          _communities.doc(communityModel.name).set(communityModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(failure: e.toString()));
    }
  }

  FutureVoid editCommunity(CommunityModel community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(failure: e.toString()));
    }
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
  Stream<List<CommunityModel>> userCommunities(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<CommunityModel> communities = [];
      for (var i in event.docs) {
        communities
            .add(CommunityModel.fromMap(i.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map((event) =>
        CommunityModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<List<CommunityModel>> searchResult(String query) {
    return _communities
        .where('name',
            isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
            isLessThan: query.substring(0, query.length - 1) +
                String.fromCharCode(query.codeUnitAt(query.length - 1) - 1))
        .snapshots()
        .map((event) {
      List<CommunityModel> communities = [];
      for (var val in event.docs) {
        communities
            .add(CommunityModel.fromMap(val.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }
}
