import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/constants/app_colors.dart';
import 'package:eventify/screens/settings/verification_form_screen.dart';
import 'package:eventify/cubits/profile/profile_cubit.dart';
import 'package:eventify/cubits/profile/profile_state.dart';

class VerificationDetailsScreen extends StatelessWidget {
  const VerificationDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final isVerified = state.user?.isCertified == true;

        return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Account Verification',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Verification Status Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isVerified ? Colors.green.shade50 : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isVerified ? Colors.green : Colors.orange,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          isVerified ? Icons.verified : Icons.info_outline,
                          size: 80,
                          color: isVerified ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isVerified ? 'You Are Verified!' : 'Account Not Verified',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isVerified ? Colors.green.shade900 : Colors.orange.shade900,
                            fontFamily: 'JosefinSans',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isVerified
                              ? 'Your account is verified. You can create and post events.'
                              : 'Verify your account to create and post events on Eventify.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: isVerified ? Colors.green.shade700 : Colors.orange.shade700,
                            fontFamily: 'JosefinSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Benefits Section
                  const Text(
                    'Verification Benefits',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'JosefinSans',
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildBenefitItem(
                    icon: Icons.post_add,
                    title: 'Create Events',
                    description: 'Post your own events and reach a wider audience',
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitItem(
                    icon: Icons.verified_user,
                    title: 'Verified Badge',
                    description: 'Get a verified badge on your profile',
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitItem(
                    icon: Icons.trending_up,
                    title: 'Priority Visibility',
                    description: 'Your events get priority in search results',
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitItem(
                    icon: Icons.analytics,
                    title: 'Event Analytics',
                    description: 'Access detailed analytics for your events',
                  ),
                  const SizedBox(height: 30),

                  // Verification Requirements
                  if (!isVerified) ...[
                    const Text(
                      'Requirements',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRequirementItem('Valid government-issued ID'),
                          const SizedBox(height: 8),
                          _buildRequirementItem('Proof of address'),
                          const SizedBox(height: 8),
                          _buildRequirementItem('Active phone number'),
                          const SizedBox(height: 8),
                          _buildRequirementItem('Complete profile information'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Verify Account Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VerificationFormScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Verify My Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'JosefinSans',
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  },
);
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryDark,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'JosefinSans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontFamily: 'JosefinSans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: AppColors.primaryDark,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontFamily: 'JosefinSans',
            ),
          ),
        ),
      ],
    );
  }
}
