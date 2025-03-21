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
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'user-not-found':
          _errorMessage = 'Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı';
          break;
        case 'wrong-password':
          _errorMessage = 'Hatalı şifre';
          break;
        case 'invalid-email':
          _errorMessage = 'Geçersiz e-posta adresi';
          break;
        case 'user-disabled':
          _errorMessage = 'Bu hesap devre dışı bırakılmış';
          break;
        default:
          _errorMessage = 'Giriş yapılırken bir hata oluştu: ${e.message}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      // Kullanıcıyı oluştur
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kullanıcı başarıyla oluşturuldu ve otomatik olarak giriş yapıldı
      if (userCredential.user != null) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw FirebaseAuthException(
          code: 'null-user',
          message: 'Kullanıcı oluşturulamadı',
        );
      }
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'email-already-in-use':
          _errorMessage = 'Bu e-posta adresi zaten kullanımda';
          break;
        case 'invalid-email':
          _errorMessage = 'Geçersiz e-posta adresi';
          break;
        case 'operation-not-allowed':
          _errorMessage = 'E-posta/şifre hesapları etkin değil';
          break;
        case 'weak-password':
          _errorMessage = 'Şifre çok zayıf';
          break;
        default:
          _errorMessage = 'Kayıt olurken bir hata oluştu: ${e.message}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';
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

      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Çıkış yapılırken bir hata oluştu: ${e.toString()}';
      notifyListeners();
    }
  }
}
