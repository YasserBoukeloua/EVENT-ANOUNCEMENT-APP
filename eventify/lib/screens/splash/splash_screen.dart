import 'package:flutter/material.dart';
import 'package:eventify/constants/app_colors.dart';
import 'package:eventify/main.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _expandController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _purpleOverlayAnimation;

  @override
  void initState() {
    super.initState();
    
    // Slide up from bottom to center animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 3.0), // Start well below screen
      end: Offset.zero, // End at center
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    // Expand and fade out animation
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 20.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInQuart,
    ));
    
    _fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeIn,
    ));
    
    _purpleOverlayAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeIn,
    ));
    
    // Start: E slides up from bottom to center
    _slideController.forward();
    
    // After E reaches center, wait 400ms then start zoom
    Timer(const Duration(milliseconds: 1200), () {
      _expandController.forward();
    });
    
    // Navigate to login when zoom/expansion completes
    Timer(const Duration(milliseconds: 2000), () {
      _navigateToLogin();
    });
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeApp(),
      ),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // White/Light background (inverted from purple gradient)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF5F5F5),
                  Color(0xFFFFFFFF),
                  Color(0xFFFAFAFA),
                ],
              ),
            ),
          ),
          
          // Letter 'e' that slides, zooms, and fades out (now purple)
          Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeOutAnimation,
                  child: Text(
                    'e',
                    style: const TextStyle(
                      fontSize: 180,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      fontFamily: 'JosefinSans',
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Purple overlay that fades in to cover screen (inverted from white)
          AnimatedBuilder(
            animation: _purpleOverlayAnimation,
            builder: (context, child) {
              return Container(
                color: AppColors.primaryDark.withOpacity(_purpleOverlayAnimation.value),
              );
            },
          ),
        ],
      ),
    );
  }
}