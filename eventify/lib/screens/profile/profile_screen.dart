import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/constants/app_colors.dart';
import 'package:eventify/localization/app_language.dart';
import 'package:eventify/screens/settings/settings_screen.dart';
import 'package:eventify/screens/login/login_screen.dart';
import 'package:eventify/cubits/profile/profile_cubit.dart';
import 'package:eventify/cubits/profile/profile_state.dart';
import 'package:eventify/cubits/favorites/favorites_cubit.dart';
import 'package:eventify/cubits/favorites/favorites_state.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          AppLanguage.t('profile_logout_title'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'JosefinSans'),
        ),
        content: Text(AppLanguage.t('profile_logout_confirm'), style: const TextStyle(fontFamily: 'JosefinSans')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              AppLanguage.t('profile_cancel'),
              style: TextStyle(color: Colors.grey, fontFamily: 'JosefinSans'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              
              // Logout via Cubit
              context.read<ProfileCubit>().logout();

              // Navigate back to login screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLanguage.t('profile_logout_success'), style: const TextStyle(fontFamily: 'JosefinSans')),
                  backgroundColor: AppColors.accentAlt,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: Text(
              AppLanguage.t('profile_logout'),
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontFamily: 'JosefinSans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditInfoDialog(BuildContext context, String field, String currentValue) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Edit $field',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'JosefinSans',
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: field,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              AppLanguage.t('profile_cancel'),
              style: TextStyle(fontFamily: 'JosefinSans'),
            ),
          ),
          TextButton(
            onPressed: () {
              final newValue = controller.text.trim();
              if (newValue.isEmpty) {
                Navigator.pop(dialogContext);
                return;
              }

              // Update via ProfileCubit
              final profileCubit = context.read<ProfileCubit>();
              if (field == 'Username') {
                profileCubit.updateUsername(newValue);
              } else if (field == 'Email') {
                profileCubit.updateEmail(newValue);
              }

              Navigator.pop(dialogContext);
            },
            child: Text(
              AppLanguage.t('profile_save'),
              style: TextStyle(
                color: AppColors.accentAlt,
                fontFamily: 'JosefinSans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
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
              // Header with gradient
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
                            // Back button removed
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
                                icon: Icons.event,
                                label: AppLanguage.t('profile_attended'),
                                value: eventsAttended.toString(),
                                color: Colors.green,
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

              // Main content
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundMedium,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Personal Information Section
                        Text(
                          AppLanguage.t('profile_personal_info'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'JosefinSans',
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildInfoCard(context, AppLanguage.t('profile_username'), username, Icons.person_outline),
                        const SizedBox(height: 12),
                        _buildInfoCard(context, AppLanguage.t('profile_email'), email, Icons.email_outlined),
                        const SizedBox(height: 30),



                        // Manage my account section
                        Text(
                          AppLanguage.t('profile_manage_account'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'JosefinSans',
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildMenuItem(AppLanguage.t('profile_ad_prefs'), Icons.ads_click, () {}),
                        const SizedBox(height: 12),
                        _buildMenuItem(AppLanguage.t('profile_session_mgmt'), Icons.security, () {}),
                        const SizedBox(height: 12),
                        _buildMenuItem(AppLanguage.t('profile_browser_settings'), Icons.browser_updated, () {}),
                        const SizedBox(height: 30),

                        // App & Privacy section
                        Text(
                          AppLanguage.t('profile_app_privacy'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'JosefinSans',
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildMenuItem(AppLanguage.t('profile_my_privacy_data'), Icons.privacy_tip, () {}),
                        const SizedBox(height: 12),
                        _buildMenuItem(AppLanguage.t('profile_logout'), Icons.logout, () => _showLogoutDialog(context), isLogout: true),
                        const SizedBox(height: 100),
                      ],
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

  Widget _buildInfoCard(BuildContext context, String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.backgroundMediumDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryMedium, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                    fontFamily: 'JosefinSans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'JosefinSans',
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.primaryMedium,
              size: 22,
            ),
            onPressed: () => _showEditInfoDialog(context, label, value),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.backgroundMediumDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'JosefinSans',
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'JosefinSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap, {bool isLogout = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isLogout ? Colors.red.shade50 : AppColors.backgroundMediumDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: isLogout ? Colors.red.shade700 : AppColors.primaryMedium,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isLogout ? Colors.red.shade700 : Colors.black,
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 24,
              color: isLogout ? Colors.red.shade700 : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}


