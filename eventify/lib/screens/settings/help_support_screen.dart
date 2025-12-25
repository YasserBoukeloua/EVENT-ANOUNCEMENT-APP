import 'package:flutter/material.dart';
import 'package:eventify/constants/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'JosefinSans',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to use Eventify',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JosefinSans',
                ),
              ),
              SizedBox(height: 12),
              Text(
                '• Browse events from the home screen using the All, Recent, and Closest filters.\n\n'
                '• Tap an event card to see full details, register, and read comments.\n\n'
                '• Use the bottom navigation bar to access your favorites and profile.\n\n'
                '• In Settings, adjust your notifications, event preferences, and language.\n\n'
                '• If you get lost, you can always return to the home screen and start again.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  fontFamily: 'JosefinSans',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




