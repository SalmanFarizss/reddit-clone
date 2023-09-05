import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_5/core/constants/constants.dart';
import 'package:project_5/core/providers/storage_repository_provider.dart';
import 'package:project_5/core/utilities.dart';
import 'package:project_5/features/auth/controller/auth_controller.dart';
import 'package:project_5/models/community_models.dart';
import 'package:routemaster/routemaster.dart';
import '../repository/community_repository.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) =>
        CommunityController(
            communityRepository: ref.read(communityRepositoryProvider),
            storageRepository: ref.read(storageRepositoryProvider),
            ref: ref));
final userCommunitiesProvider = StreamProvider(
    (ref) => ref.watch(communityControllerProvider.notifier).userCommunities());
final nameCommunityProvider = StreamProvider.family((ref, String name) =>
    ref.watch(communityControllerProvider.notifier).getCommunityByName(name));
final searchResultProvider = StreamProvider.family((ref, String query) =>
    ref.watch(communityControllerProvider.notifier).searchResult(query));

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  CommunityController(
      {required CommunityRepository communityRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _communityRepository = communityRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);
  Future<void> createCommunity(String name, BuildContext context) async {
    state = true;
    final String uid = _ref.read(userProvider)!.uid;
    CommunityModel communityModel = CommunityModel(
        id: name,
        name: name,
        banner: Constants.bannerDefault,
        avatar: Constants.avatarDefault,
        members: [uid],
        mods: [uid]);
    final res = await _communityRepository.createCommunity(communityModel);
    state = false;
    res.fold((l) => errorSnackBar(context, l.failure), (r) {
      errorSnackBar(context, 'Community created successfully');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<CommunityModel>> userCommunities() {
    final String uid = _ref.read(userProvider)!.uid;
    return _communityRepository.userCommunities(uid);
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity(
      {required CommunityModel community,
      required BuildContext context,
      required File? avatarFile,
      required File? bannerFile}) async {
    state = true;
    if (avatarFile != null) {
      final res = await _storageRepository.storeFile(
          'communities/avatar', community.name, avatarFile);
      res.fold((l) => errorSnackBar(context, l.failure),
          (r) => community = community.copyWith(avatar: r));
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          'communities/banner', community.name, bannerFile);
      res.fold((l) => errorSnackBar(context, l.failure),
          (r) => community = community.copyWith(banner: r));
    }
    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold((l) => errorSnackBar(context, l.failure),
        (r) => Routemaster.of(context).pop());
  }

  Stream<List<CommunityModel>> searchResult(String query) {
    return _communityRepository.searchResult(query);
  }
}
