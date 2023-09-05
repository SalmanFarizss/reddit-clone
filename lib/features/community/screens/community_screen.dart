import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_5/core/common/circle_loader.dart';
import 'package:project_5/core/common/error_text.dart';
import 'package:project_5/features/auth/controller/auth_controller.dart';
import 'package:project_5/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key,required this.name});
  void navigateToModeTools(BuildContext context){
    Routemaster.of(context).push('/mod_tools/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user=ref.read(userProvider)!;
    return Scaffold(
      body:ref.watch(nameCommunityProvider(name)).when(
          data: (data) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    flexibleSpace:Image.network(data.banner,fit: BoxFit.cover,)
                  ),
                   SliverPadding(
                      padding: const EdgeInsets.all(16),
                     sliver: SliverList(delegate: SliverChildListDelegate(
                       [
                         Align(alignment: Alignment.centerLeft,child: CircleAvatar(backgroundImage: NetworkImage(data.avatar),radius: 35,)),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('r/${data.name}',style:const TextStyle(fontWeight: FontWeight.bold),),
                             data.mods.contains(user.uid)?
                             OutlinedButton(
                                 onPressed: () {
                                   navigateToModeTools(context);
                                 },
                               style: ElevatedButton.styleFrom(
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                 padding: const EdgeInsets.symmetric(horizontal: 25)
                               ),
                                 child:const Text('Mod tools'),
                             ):OutlinedButton(
                               onPressed: () {},
                               style: ElevatedButton.styleFrom(
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                   padding: const EdgeInsets.symmetric(horizontal: 25)
                               ),
                               child:data.members.contains(user.uid)?const Text('join'):const Text('joined')
                             )
                           ],
                         ),
                          Padding(padding: const EdgeInsets.only(top: 5),child: Text('members:${data.members.length}'),)
                       ]
                     ),

                     ),
                   ),
                ];
              },
              body:const Text('this is text') ),
          error: (error, stackTrace) => ErrorText(text: error.toString()),
          loading: () =>const CircleLoader(),) ,
    );
  }
}
