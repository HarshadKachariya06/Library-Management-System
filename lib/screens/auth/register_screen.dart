import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  final AuthService authService = AuthService.instance;

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _agreeTerms = true;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept Terms and Privacy Policy'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await authService.registerWithEmailPassword(
        name: name.text.trim(),
        email: email.text.trim(),
        password: password.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully")),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xffF4FAF7);
    const cardColor = Colors.white;
    const primary = Color(0xff1DBA7B);
    const textDark = Color(0xff182230);
    const textLight = Color(0xff7C8798);
    const borderColor = Color(0xffD7DEE7);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
              child: Row(
                children: [
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'StL',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Lumina Library',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: textLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Support',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 390),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 28,
                          ),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Join the Library',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: textDark,
                                    height: 1.08,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Create an account to start your literary journey.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textLight,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                _label('FULL NAME'),
                                const SizedBox(height: 8),
                                _input(
                                  controller: name,
                                  hint: 'Enter your name',
                                  validator: Validators.name,
                                  borderColor: borderColor,
                                ),
                                const SizedBox(height: 16),
                                _label('EMAIL ADDRESS'),
                                const SizedBox(height: 8),
                                _input(
                                  controller: email,
                                  hint: 'name@library.com',
                                  validator: Validators.email,
                                  borderColor: borderColor,
                                ),
                                const SizedBox(height: 16),
                                _label('PASSWORD'),
                                const SizedBox(height: 8),
                                _input(
                                  controller: password,
                                  hint: 'Create a password',
                                  obscure: _obscurePassword,
                                  validator: Validators.password,
                                  borderColor: borderColor,
                                  suffixIcon: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    child: Text(
                                      _obscurePassword ? 'visibility' : 'hide',
                                      style: const TextStyle(
                                        color: Color(0xff98A2B3),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Transform.scale(
                                      scale: 0.9,
                                      child: Checkbox(
                                        value: _agreeTerms,
                                        activeColor: primary,
                                        side: const BorderSide(
                                          color: Color(0xffCBD5E1),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _agreeTerms = value ?? false;
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 11),
                                        child: RichText(
                                          text: const TextSpan(
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: textLight,
                                              height: 1.5,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    'By creating an account, you agree to our ',
                                              ),
                                              TextSpan(
                                                text: 'Terms',
                                                style: TextStyle(
                                                  color: primary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              TextSpan(text: ' and '),
                                              TextSpan(
                                                text: 'Privacy.',
                                                style: TextStyle(
                                                  color: primary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed:
                                        _isLoading ? null : _handleRegister,
                                    style: ElevatedButton.styleFrom(
                                      elevation: 6,
                                      shadowColor:
                                          primary.withValues(alpha: 0.35),
                                      backgroundColor: primary,
                                      disabledBackgroundColor:
                                          primary.withValues(alpha: 0.6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.4,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Create Account',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                              Icon(
                                                Icons.arrow_forward,
                                                size: 18,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                      const Text(
                                        'Already have an account? ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: textLight,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            AppRoutes.login,
                                          );
                                        },
                                        child: const Text(
                                          'Log In',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          '© 2024 Lumina Library Management System. All rights reserved.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xff98A2B3),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Color(0xff98A2B3),
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    required Color borderColor,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xff182230),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xffA0AEC0),
          fontSize: 13,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xff1DBA7B),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.3),
        ),
      ),
    );
  }
}
