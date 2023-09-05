import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_5/core/utilities.dart';
import 'package:project_5/features/auth/repository/auth_repository.dart';
import '../../../models/user_model.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(
        authRepository: ref.watch(authRepositoryProvider), ref: ref));
final userProvider = StateProvider<UserModel?>((ref) => null);
final authStateChangeProvider = StreamProvider(
  (ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.authStateChange;
  },
);
final getUserDataProvider=StreamProvider.family((ref,String uid) {
  final authController=ref.watch(authControllerProvider.notifier);
  return authController.getUser(uid);
},);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);
  Stream<User?> get authStateChange => _authRepository.authStateChange;
  Future<void> signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
        (l) => errorSnackBar(context, l.failure),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  Stream<UserModel> getUser(String uid) {
    return _authRepository.getUser(uid);
  }
}
