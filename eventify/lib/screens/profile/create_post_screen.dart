import 'package:flutter/material.dart';
import 'package:eventify/constants/app_colors.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMedium,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          'Create Post',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'JosefinSans',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Create Post Page',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'JosefinSans',
          ),
        ),
      ),
    );
  }
}
