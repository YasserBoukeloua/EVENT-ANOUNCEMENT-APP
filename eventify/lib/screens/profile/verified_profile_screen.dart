import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/constants/app_colors.dart';
import 'package:eventify/localization/app_language.dart';
import 'package:eventify/screens/settings/settings_screen.dart';
import 'package:eventify/screens/profile/create_post_screen.dart';
import 'package:eventify/screens/login/login_prompt_screen.dart';
import 'package:eventify/cubits/profile/profile_cubit.dart';
import 'package:eventify/cubits/profile/profile_state.dart';
import 'package:eventify/cubits/favorites/favorites_cubit.dart';
import 'package:eventify/cubits/favorites/favorites_state.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class VerifiedProfilePage extends StatelessWidget {
  const VerifiedProfilePage({Key? key}) : super(key: key);

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _navigateToCreatePost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePostScreen()),
    );
  }

  Future<void> _changeProfilePicture(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Get app directory
        final directory = await getApplicationDocumentsDirectory();
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}';
        final String savedPath = path.join(directory.path, fileName);

        // Copy image to app directory
        await File(image.path).copy(savedPath);

        // Update profile
        if (context.mounted) {
          context.read<ProfileCubit>().updateProfilePicture(savedPath);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        // Check if user is authenticated
        final isAuthenticated = profileState.user != null;

        if (!isAuthenticated) {
          // Show login prompt for unauthenticated users
          return const LoginPromptScreen(
            featureName: 'Profile',
            description: 'Please log in or sign up to access your profile and create posts',
          );
        }

        // Get user data from ProfileCubit state
        final user = profileState.user;
        final username = user?.username ?? 'Guest';
        final email = user?.email ?? 'guest@example.com';
        final userScore = 1250; // From userStats when available
        final eventsAttended = 12; // From userStats when available
        final eventsCreated = 3; // From userStats when available

        return Scaffold(
          backgroundColor: AppColors.backgroundMedium,
          body: Column(
            children: [
              // Header with gradient (inherited from profile page)
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
                    child: Column(
                      children: [
                        // Settings button at top
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLanguage.t('profile_title'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'JosefinSans',
                              ),
                            ),
                            IconButton(
                              onPressed: () => _navigateToSettings(context),
                              icon: const Icon(
                                Icons.settings_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _changeProfilePicture(context),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                  image: user?.photo != null
                                      ? DecorationImage(
                                          image: FileImage(File(user!.photo!)),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: user?.photo == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 45,
                                        color: AppColors.primaryMedium,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'JosefinSans',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    email,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontFamily: 'JosefinSans',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // User Score Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildScoreItem(
                                icon: Icons.star,
                                label: AppLanguage.t('profile_score'),
                                value: userScore.toString(),
                                color: Colors.amber,
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              _buildScoreItem(
                                icon: Icons.add_circle_outline,
                                label: AppLanguage.t('profile_created'),
                                value: eventsCreated.toString(),
                                color: Colors.blue,
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              // Real-time Favorites count from Cubit
                              BlocBuilder<FavoritesCubit, FavoritesState>(
                                builder: (context, state) {
                                  int favCount = 0;
                                  if (state is FavoritesLoaded) {
                                    favCount = state.favorites.length;
                                  }
                                  return _buildScoreItem(
                                    icon: Icons.favorite,
                                    label: AppLanguage.t('profile_favorites'),
                                    value: favCount.toString(),
                                    color: Colors.red,
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

              // Main content - show create post button only for verified users
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundMedium,
                  ),
                  child: Center(
                    child: user?.isCertified == true
                        ? ElevatedButton(
                            onPressed: () => _navigateToCreatePost(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryDark,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Create Post',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'JosefinSans',
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.verified_user_outlined,
                                    size: 60,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Verification Required',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'JosefinSans',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'You need to verify your account to create posts and events',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontFamily: 'JosefinSans',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),
                                ElevatedButton(
                                  onPressed: () => _navigateToSettings(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Verify Account',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'JosefinSans',
                                    ),
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
        );
      },
    );
  }

  Widget _buildScoreItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'JosefinSans',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontFamily: 'JosefinSans',
          ),
        ),
      ],
    );
  }
}
