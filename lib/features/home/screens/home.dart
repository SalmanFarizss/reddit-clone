import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_5/features/auth/controller/auth_controller.dart';
import 'package:project_5/features/home/delegate/search_community_delegate.dart';
import 'package:project_5/features/home/drawers/community_drawer.dart';
import 'package:project_5/features/home/drawers/profile_drawer.dart';

class Home extends ConsumerWidget {
  const Home({super.key});
  void openDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }
  void openEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final user=ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder:(context1) =>  IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              openDrawer(context1);
            },),
        ),
        title: const Text('Home'),
        actions: [
          IconButton(onPressed: () {
            showSearch(context: context, delegate: SearchCommunityDelegate(ref: ref));
          },
              icon: const Icon(Icons.search)),
          IconButton(
            icon: CircleAvatar(
              backgroundImage:NetworkImage(user.profile),
            ), onPressed: () =>openEndDrawer(context),
          )
        ],
      ),
      drawer: const CommunityDrawer(),
      endDrawer:const ProfileDrawer(),
      body: Center(
        child:Text(user.name),
      ),
    );
  }
}
