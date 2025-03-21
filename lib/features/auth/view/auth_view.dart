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
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      'GlobeConnect',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 58,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3.0,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.blue.withOpacity(0.7),
                            offset: const Offset(0, 5),
                            blurRadius: 15,
                          ),
                          Shadow(
                            color: Colors.white.withOpacity(0.5),
                            offset: const Offset(0, -2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Dünya Senin Ellerinde',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 3.0,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.blue.withOpacity(0.4),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: context.read<AuthViewModel>().isLoading
                              ? null
                              : () async {
                                  final success = await context
                                      .read<AuthViewModel>()
                                      .signInWithGoogle();
                                  if (success && mounted) {
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                  }
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/google_logo1.png',
                                  height: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Google ile Giriş Yap',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'veya',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                hintText: 'E-posta adresinizi girin',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.35),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                errorStyle: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 20,
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
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.left,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Şifrenizi girin',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.35),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                errorStyle: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 20,
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
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade600,
                                        foregroundColor: Colors.white,
                                        minimumSize:
                                            const Size(double.infinity, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                        shadowColor:
                                            Colors.blue.withOpacity(0.3),
                                      ),
                                      onPressed: () async {
                                        if (_isLogin) {
                                          await _handleSignIn(context);
                                        } else {
                                          await _handleSignUp(context);
                                        }
                                      },
                                      child: Text(
                                        'Giriş Yap',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/register');
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text(
                                      'Kayıt Ol',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
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

  Future<void> _handleSignIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final success = await Provider.of<AuthViewModel>(context, listen: false)
          .signInWithEmail(_emailController.text, _passwordController.text);
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  Future<void> _handleSignUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final success = await Provider.of<AuthViewModel>(context, listen: false)
          .signUpWithEmail(_emailController.text, _passwordController.text);
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }
}
