import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_5/core/common/circle_loader.dart';
import 'package:project_5/core/common/error_text.dart';
import 'package:project_5/features/auth/controller/auth_controller.dart';
import 'package:project_5/router.dart';
import 'package:project_5/theme/pallet.dart';
import 'package:routemaster/routemaster.dart';
import 'models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(
        apiKey: "AIzaSyB6wCwElumg0nT7kNQLdEWd6wjf9oYf-uY",
        projectId: "project5-fa41c",
        messagingSenderId: "920819475962",
        appId: "1:920819475962:web:bfd54460745e5ab36f7043",
       ));
  }else {
    await Firebase.initializeApp()
        .whenComplete(() => print('initialization completed'));
  }
  runApp(const ProviderScope(child: MyApp()));
}
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}
class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  Future<void> getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUser(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
      data: (data) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: Pallete.darkModeAppTheme,
        title: 'project_5',
        routerDelegate:
        RoutemasterDelegate(routesBuilder:(context) {
          if (data != null) {
            getData(ref, data);

            if (userModel != null) {
              return loggedInRoute;
            }
          }
          return loggedOutRoute;
        },
        ),
        routeInformationParser: const RoutemasterParser(),
      ),
      error: (error, stackTrace) => ErrorText(text: error.toString()),
      loading: () => const CircleLoader(),
    );
  }
}
