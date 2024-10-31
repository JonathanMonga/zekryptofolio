import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final currentUser = Supabase.instance.client.auth.currentUser;

  Future<void> googleSignIn() async {
    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken,
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp(String name,
      {required String email, required String password}) async {
    await Supabase.instance.client.auth
        .signUp(email: email, password: password, data: {
      "name": name,
    });
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  Stream<AuthState> getAuthStateChange() {
    return Supabase.instance.client.auth.onAuthStateChange;
  }
}
