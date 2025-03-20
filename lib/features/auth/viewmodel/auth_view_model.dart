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
  User? get currentUser => _auth.currentUser;

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      _isLoading = false;
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
      _errorMessage = '';
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      _isLoading = false;
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
      _errorMessage = '';
      notifyListeners();

      // Önce mevcut oturumları temizle
      await _auth.signOut();
      await _googleSignIn.signOut();

      // Google hesap seçiciyi göster
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _isLoading = false;
        _errorMessage = 'Google hesabı seçilmedi';
        notifyListeners();
        return false;
      }

      try {
        // Google kimlik doğrulama bilgilerini al
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Firebase kimlik bilgilerini oluştur
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Firebase ile giriş yap
        final userCredential = await _auth.signInWithCredential(credential);

        if (userCredential.user == null) {
          throw FirebaseAuthException(
            code: 'null-user',
            message: 'Kullanıcı bilgileri alınamadı',
          );
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } catch (authError) {
        await _googleSignIn.signOut();
        throw authError;
      }
    } catch (e) {
      _isLoading = false;
      if (e is FirebaseAuthException) {
        _errorMessage = 'Giriş hatası: ${e.message}';
      } else {
        _errorMessage =
            'Google ile giriş yapılırken bir hata oluştu: ${e.toString()}';
      }
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      await _auth.signOut();
      await _googleSignIn.signOut();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Çıkış yapılırken bir hata oluştu: ${e.toString()}';
      notifyListeners();
    }
  }
}
