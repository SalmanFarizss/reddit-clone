import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_5/core/common/circle_loader.dart';
import 'package:project_5/features/community/controller/community_controller.dart';

class NewCommunity extends ConsumerStatefulWidget {
  const NewCommunity({super.key});

  @override
  ConsumerState createState() => _NewCommunityState();
}

class _NewCommunityState extends ConsumerState<NewCommunity> {
  final communityName=TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    communityName.dispose();
  }
  void createCommunity({required String name,required BuildContext context}){
    ref.read(communityControllerProvider.notifier).createCommunity(name, context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading=ref.read(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a community'),
      ),
      body: isLoading?const CircleLoader(): Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('Community name',style: TextStyle(fontSize: 15),)
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: communityName,
              decoration:const InputDecoration(
                hintText:'r/Community_name',
                contentPadding: EdgeInsets.all(18),
                filled: true,
                border: InputBorder.none
              ),
              maxLength: 20,
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () {
                createCommunity(name: communityName.text.trim(), context: context);
              },
              style:  ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
              ), 
              child:  const Text('Create community'),
              
            )
          ],
        ),
      ),
    );
  }
}
