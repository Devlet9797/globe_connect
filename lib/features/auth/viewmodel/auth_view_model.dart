import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      _errorMessage = '';
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Giriş yapılırken bir hata oluştu: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _isLoading = false;
      _errorMessage = '';
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Kayıt olurken bir hata oluştu: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        _errorMessage = 'Google ile giriş iptal edildi';
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      _isLoading = false;
      _errorMessage = '';
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage =
          'Google ile giriş yapılırken bir hata oluştu: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
