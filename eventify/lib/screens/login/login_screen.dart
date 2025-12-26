import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/constants/app_colors.dart';
import 'package:eventify/main.dart';
import 'package:eventify/localization/app_language.dart';
import 'package:eventify/screens/login/sign_up/sign_up_screen.dart';
import 'package:eventify/repositories/auth_repository.dart';
import 'package:eventify/cubits/auth/login/login_cubit.dart';
import 'package:eventify/cubits/auth/login/login_state.dart';
import 'package:eventify/cubits/profile/profile_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(AuthRepository()),
      child: const LoginScreenContent(),
    );
  }
}

class LoginScreenContent extends StatefulWidget {
  const LoginScreenContent({super.key});

  @override
  State<LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<LoginScreenContent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Update the profile cubit with the logged-in user
            context.read<ProfileCubit>().setUser(state.user);
            
            // Navigate to home on successful login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeApp()),
            );
          } else if (state is LoginFailure) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryDarkest,
                AppColors.primaryMedium,
                Color(0xFF3d2a5e),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeApp()),
                        (route) => false,
                      ),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(height: 20),
                    // Logo/App Name
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.event,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            AppLanguage.t('login_app_name'),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'JosefinSans',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLanguage.t('login_app_tagline'),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.7),
                              fontFamily: 'JosefinSans',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Welcome Text
                    Text(
                      AppLanguage.t('login_welcome'),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLanguage.t('login_signin_desc'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Email Field
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white, fontFamily: 'JosefinSans'),
                      decoration: InputDecoration(
                        hintText: AppLanguage.t('login_email_hint'),
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontFamily: 'JosefinSans'),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFF9B8AFB), width: 2),
                        ),
                        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF9B8AFB)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white, fontFamily: 'JosefinSans'),
                      decoration: InputDecoration(
                        hintText: AppLanguage.t('login_password_hint'),
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontFamily: 'JosefinSans'),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFF9B8AFB), width: 2),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9B8AFB)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Remember Me & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            final cubit = context.read<LoginCubit>();
                            return Row(
                              children: [
                                Checkbox(
                                  value: cubit.rememberMe,
                                  onChanged: (value) {
                                    cubit.toggleRememberMe(value ?? false);
                                    setState(() {}); // Force rebuild to show change
                                  },
                                  fillColor: MaterialStateProperty.resolveWith((states) {
                                    if (states.contains(MaterialState.selected)) {
                                      return const Color(0xFF9B8AFB);
                                    }
                                    return Colors.transparent;
                                  }),
                                  side: BorderSide(color: Colors.white.withOpacity(0.5)),
                                  checkColor: Colors.white,
                                ),
                                Text(
                                  AppLanguage.t('login_remember_me'),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontFamily: 'JosefinSans',
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            // Forgot password functionality
                          },
                          child: Text(
                            AppLanguage.t('login_forgot_password'),
                            style: TextStyle(
                              color: Color(0xFF9B8AFB),
                              fontFamily: 'JosefinSans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Login Button with Loading State
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        final isLoading = state is LoginLoading;
                        
                        return SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.read<LoginCubit>().login(
                                          _emailController.text,
                                          _passwordController.text,
                                        );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9B8AFB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    AppLanguage.t('login_signin_button'),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'JosefinSans',
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            AppLanguage.t('login_or'),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontFamily: 'JosefinSans',
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Google Sign In
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Google sign in functionality
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withOpacity(0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.g_mobiledata, color: Colors.white, size: 32),
                        label: Text(
                          AppLanguage.t('login_google_signin'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'JosefinSans',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Sign Up Link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLanguage.t('login_no_account'),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontFamily: 'JosefinSans',
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUpScreen()),
                              );
                            },
                            child: Text(
                              AppLanguage.t('login_signup_link'),
                              style: TextStyle(
                                color: Color(0xFF9B8AFB),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'JosefinSans',
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
          ),
        ),
      ),
    );
  }
}


