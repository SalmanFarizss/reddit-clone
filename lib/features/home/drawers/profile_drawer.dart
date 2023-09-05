import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_5/features/auth/controller/auth_controller.dart';
import 'package:project_5/theme/pallet.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user=ref.read(userProvider);
    return Drawer(
      child: SafeArea(
        child: Column(children: [
          CircleAvatar(
            backgroundImage:NetworkImage(user!.profile),
            radius: 70,
          ),
          const SizedBox(height: 10,),
          Text('u/${user.name}',style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 30),),
          const SizedBox(height: 10,),
          const Divider(),
          ListTile(
            title:const Text('My profile') ,
            leading: const Icon(Icons.person),
            onTap: () {},
          ),
          const SizedBox(height: 10,),
          ListTile(
            title:const Text('Log out') ,
            leading:Icon(Icons.logout,color: Pallete.redColor,),
            onTap: (){},
          ),
          const SizedBox(height: 10,),
          Switch.adaptive(value: true, onChanged: (value) {},)
        ],),
      ),
    );
  }
}
