import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_5/core/common/circle_loader.dart';
import 'package:project_5/core/common/error_text.dart';
import 'package:project_5/features/community/controller/community_controller.dart';
import 'package:project_5/models/community_models.dart';
import 'package:routemaster/routemaster.dart';

class CommunityDrawer extends ConsumerWidget {
  const CommunityDrawer({super.key});
  void navigateFunc(BuildContext context){
    Routemaster.of(context).push('/create_community');
  }
  void navigateCom(BuildContext context,String name){
    Routemaster.of(context).push('/r/$name');
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  Drawer(
      child: SafeArea(child: Column(
        children: [
          ListTile(
            title:const Text('Add a community') ,
            leading: const Icon(Icons.add),
            onTap: () => navigateFunc(context),
          ),
          ref.watch(userCommunitiesProvider).when(data: (communities) => Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) {
                  CommunityModel community=communities[index];
                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(community.avatar),),
                    title: Text('r/${community.name}'),
                    onTap: () => navigateCom(context, community.name),
                  );
                },
                itemCount:communities.length ),
          ),
            error: (error, stackTrace) =>ErrorText(text: error.toString()),
            loading:() => const CircleLoader(),)
        ],
      )),
    );
  }
}
