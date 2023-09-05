import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModTools extends StatelessWidget {
  final String name;
  const ModTools({super.key,required this.name});
  void navigateToEditCommunity(BuildContext context){
    Routemaster.of(context).push('/edit_community/$name');
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading:const Icon(Icons.add_moderator),
              title:const Text('Add moderators'),
              onTap: () {},
            ),
            const SizedBox(height: 10,),
            ListTile(
              leading:const Icon(Icons.edit),
              title:const Text('Edit community'),
              onTap: () {
                navigateToEditCommunity(context);
              },
            ),

          ],
        ),
      ),
    );
  }
}
