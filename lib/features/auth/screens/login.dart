import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_5/core/common/circle_loader.dart';
import 'package:project_5/features/auth/controller/auth_controller.dart';
import '../../../core/common/signin_button.dart';
import '../../../core/constants/constants.dart';
class Login extends ConsumerWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isLoading=ref.watch(authControllerProvider);
    return Scaffold(
      appBar:AppBar(
        leading: const SizedBox(),
        title: Center(
          child: Image.asset(Constants.logoPath,
            height: 40,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text('Skip',style: TextStyle(fontWeight: FontWeight.bold)),)
        ],
      ),
      body: isLoading ? CircleLoader():
      Column(
        children: [
          const SizedBox(height: 20,),
          const Text('Dive into anything',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5
          ),),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(Constants.loginEmotePath,width: 400,),
          ),
          const SizedBox(height: 20,),
          SignInButton(context1: context)
        ],
      )
    );
  }
}
