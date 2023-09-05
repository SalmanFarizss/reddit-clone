import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_5/core/common/circle_loader.dart';
import 'package:project_5/core/common/error_text.dart';
import 'package:project_5/core/utilities.dart';
import 'package:project_5/features/community/controller/community_controller.dart';
import 'package:project_5/models/community_models.dart';
import 'package:project_5/theme/pallet.dart';

import '../../../core/constants/constants.dart';

class EditCommunity extends ConsumerStatefulWidget {
  final String name;
  const EditCommunity({super.key, required this.name});

  @override
  ConsumerState createState() => _EditCommunityState();
}

class _EditCommunityState extends ConsumerState<EditCommunity> {
  File? bannerFile;
  File? avatarFile;
  void pickBannerImage() async {
    final img=await selectImage();
    if(img!=null){
      setState(() {
        bannerFile=File(img.files.first.path!);
      });
    }
  }
  void pickAvatarImage() async {
    final img=await selectImage();
    if(img!=null){
      setState(() {
        avatarFile=File(img.files.first.path!);
      });
    }
  }
  void save(CommunityModel community,BuildContext context){
    ref.read(communityControllerProvider.notifier).editCommunity(
        community: community,
        context: context,
        avatarFile: avatarFile,
        bannerFile: bannerFile);
  }
  @override
  Widget build(BuildContext context) {
    final isLoading=ref.watch(communityControllerProvider);
    return ref.watch(nameCommunityProvider(widget.name)).when(
        data: (community) => Scaffold(
            appBar: AppBar(
              backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
              title: const Text('Edit Community'),
              actions: [
                TextButton(onPressed: () {
                  save(community, context);
                }, child: const Text('Save'))
              ],
            ),
            body:isLoading ? const CircleLoader(): Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: 200,
                child: Stack(children: [
                  GestureDetector(
                    onTap: () => pickBannerImage(),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      color: Colors.white,
                      strokeCap: StrokeCap.round,
                      dashPattern: const [10, 4],
                      radius: const Radius.circular(10),
                      child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child:bannerFile != null ? Image.file(bannerFile!,fit: BoxFit.cover,): community.banner.isEmpty ||
                                  community.banner == Constants.bannerDefault
                              ? const Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 40,
                                  ),
                                )
                              : Image.network(community.banner,fit: BoxFit.cover,)),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                      left: 10,
                      child: GestureDetector(
                        onTap: () => pickAvatarImage(),
                          child:avatarFile ==null?
                          CircleAvatar(backgroundImage:NetworkImage(community.avatar),radius: 30,):
                          CircleAvatar(backgroundImage:FileImage(avatarFile!),radius: 30,))),
                ]),
              ),
            )),
        error: (error, stackTrace) => ErrorText(text: error.toString()),
        loading: () => const CircleLoader());
  }
}
