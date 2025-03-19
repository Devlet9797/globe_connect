import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_view_model.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arkaplan resmi
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/world_map.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // İçerik
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    // Logo ve başlık
                    Text(
                      'GlobeConnect',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3.0,
                        height: 1.1,
                        shadows: [
                          Shadow(
                            color: Colors.blue.withOpacity(0.5),
                            offset: const Offset(0, 4),
                            blurRadius: 15,
                          ),
                          Shadow(
                            color: Colors.white.withOpacity(0.5),
                            offset: const Offset(0, -2),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Dünya Senin Ellerinde',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 4.0,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.blue.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    // Giriş formu
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // E-posta alanı
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'E-posta adresinizi girin',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3),
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16),
                                errorStyle: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Lütfen e-posta adresinizi girin';
                                }
                                if (!value.contains('@')) {
                                  return 'Geçerli bir e-posta adresi girin';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Şifre alanı
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Şifrenizi girin',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3),
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16),
                                errorStyle: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Lütfen şifrenizi girin';
                                }
                                if (value.length < 6) {
                                  return 'Şifre en az 6 karakter olmalıdır';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Şifremi unuttum linki
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // TODO: Şifre sıfırlama sayfasına yönlendir
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white70,
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Şifrenizi mi unuttunuz?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 13,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Giriş yap butonu
                          Consumer<AuthViewModel>(
                            builder: (context, authVM, child) {
                              return Column(
                                children: [
                                  if (authVM.errorMessage.isNotEmpty)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: Text(
                                        authVM.errorMessage,
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 13,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: authVM.isLoading
                                          ? null
                                          : () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                final success = _isLogin
                                                    ? await authVM
                                                        .signInWithEmail(
                                                        _emailController.text,
                                                        _passwordController
                                                            .text,
                                                      )
                                                    : await authVM
                                                        .signUpWithEmail(
                                                        _emailController.text,
                                                        _passwordController
                                                            .text,
                                                      );
                                                if (success && mounted) {
                                                  // Navigate to home page
                                                }
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.white.withOpacity(0.1),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          side: BorderSide(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: authVM.isLoading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/google_logo1.png',
                                                  height: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  'Google ile Giriş Yap',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.01),
                                                Colors.white.withOpacity(0.2),
                                                Colors.white.withOpacity(0.2),
                                                Colors.white.withOpacity(0.01),
                                              ],
                                              stops: const [0.0, 0.3, 0.7, 1.0],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'veya',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.01),
                                                Colors.white.withOpacity(0.2),
                                                Colors.white.withOpacity(0.2),
                                                Colors.white.withOpacity(0.01),
                                              ],
                                              stops: const [0.0, 0.3, 0.7, 1.0],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Kayıt ol linki
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isLogin = !_isLogin;
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white70,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                    ),
                                    child: Text(
                                      'Kayıt Ol',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
