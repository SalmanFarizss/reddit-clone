import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_5/features/auth/controller/auth_controller.dart';
import '../../theme/pallet.dart';
import '../constants/constants.dart';
class SignInButton extends ConsumerWidget {
  final BuildContext context1;
  const SignInButton({super.key,required this.context1});
  void ontapSignin({required WidgetRef ref,required BuildContext context}){
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: Pallete.greyColor,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
          ),
          onPressed: () {
            ontapSignin(ref: ref,context: context1);
          },
          icon: Image.asset(Constants.googlePath,width: 50,),
          label: const Text('Continue with google',style:TextStyle(fontSize: 18),)
      ),
    );
  }
}
