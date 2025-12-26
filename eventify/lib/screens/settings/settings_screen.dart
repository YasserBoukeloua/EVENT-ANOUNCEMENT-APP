import 'package:flutter/material.dart';
import 'package:eventify/constants/app_colors.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:eventify/localization/app_language.dart';
import 'package:eventify/screens/settings/help_support_screen.dart';
import 'package:eventify/screens/settings/verification_details_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/cubits/profile/profile_cubit.dart';
import 'package:eventify/screens/login/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = false;
  String _language = 'English';
  String _languageCode = 'en';
  String _languagePreview = '';
  
  // Event Preferences
  final List<String> _eventCategories = [
    'Technology',
    'Business',
    'Arts & Culture',
    'Sports',
    'Education',
    'Music',
    'Food & Drink',
    'Networking',
  ];
  final List<String> _selectedCategories = ['Technology', 'Business', 'Education'];
  final List<String> _preferredLocations = ['Algiers', 'Oran', 'Constantine'];
  bool _showFreeEventsOnly = false;

  @override
  void initState() {
    super.initState();
    _loadLanguagePreview();
  }

  Future<void> _loadLanguagePreview() async {
    try {
      final content =
          await rootBundle.loadString('lib/assets/lang/$_languageCode.txt');
      setState(() {
        _languagePreview = content.trim();
      });
    } catch (_) {
      setState(() {
        _languagePreview = '';
      });
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Select Language', style: TextStyle(fontFamily: 'JosefinSans')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('English'),
            _buildLanguageOption('French'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return RadioListTile<String>(
      title: Text(language, style: const TextStyle(fontFamily: 'JosefinSans')),
      value: language,
      groupValue: _language,
      activeColor: AppColors.accent,
      onChanged: (value) async {
        if (value == null) return;
        setState(() {
          _language = value;
          _languageCode = value == 'French' ? 'fr' : 'en';
          AppLanguage.setCode(_languageCode);
        });
        await _loadLanguagePreview();
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('About Eventify', style: TextStyle(fontFamily: 'JosefinSans')),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Version 1.0.0', style: TextStyle(fontFamily: 'JosefinSans')),
            const SizedBox(height: 10),
            const Text('Eventify is your go-to app for discovering and managing events.', style: TextStyle(fontFamily: 'JosefinSans')),
            const SizedBox(height: 10),
            const Text('© 2025 Eventify. All rights reserved.', style: TextStyle(fontFamily: 'JosefinSans')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
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

  @override
  Widget build(BuildContext context) {
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
                    Text(
                      AppLanguage.t('settings_title'),
                      style: const TextStyle(
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
                  // Notifications Section
                  Text(
                    AppLanguage.t('settings_notifications'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'JosefinSans',
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildSwitchTile(
                    AppLanguage.t('settings_push_notifications'),
                    AppLanguage.t('settings_push_desc'),
                    _notificationsEnabled,
                    (value) => setState(() => _notificationsEnabled = value),
                  ),
                  const SizedBox(height: 12),
                  _buildSwitchTile(
                    AppLanguage.t('settings_email_notifications'),
                    AppLanguage.t('settings_email_desc'),
                    _emailNotifications,
                    (value) => setState(() => _emailNotifications = value),
                  ),
                  const SizedBox(height: 30),

                  // Language Section
                  Text(
                    AppLanguage.t('settings_language_section'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'JosefinSans',
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildMenuTile(
                    AppLanguage.t('settings_app_language'),
                    _language,
                    _showLanguageDialog,
                  ),
                  if (_languagePreview.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      _languagePreview,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),

                  // Event Preferences Section
                  Text(
                    AppLanguage.t('settings_event_preferences'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'JosefinSans',
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildMenuTile(
                    AppLanguage.t('settings_categories'),
                    '${_selectedCategories.length} selected',
                    _showCategoriesDialog,
                  ),
                  const SizedBox(height: 12),
                  _buildMenuTile(
                    AppLanguage.t('settings_preferred_locations'),
                    '${_preferredLocations.length} locations',
                    _showLocationsDialog,
                  ),
                  const SizedBox(height: 12),
                  _buildSwitchTile(
                    AppLanguage.t('settings_free_events_only'),
                    AppLanguage.t('settings_free_events_desc'),
                    _showFreeEventsOnly,
                    (value) => setState(() => _showFreeEventsOnly = value),
                  ),
                  const SizedBox(height: 30),

                  // General Section
                  Text(
                    AppLanguage.t('settings_general'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'JosefinSans',
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildMenuTile(
                    'Account Verification',
                    '',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerificationDetailsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuTile(
                    AppLanguage.t('settings_privacy_policy'),
                    '',
                    _showPrivacyPolicyDialog,
                  ),
                  const SizedBox(height: 12),
                  _buildMenuTile(
                    AppLanguage.t('settings_terms_of_service'),
                    '',
                    _showTermsDialog,
                  ),
                  const SizedBox(height: 12),
                  _buildMenuTile(
                    AppLanguage.t('settings_about'),
                    '',
                    _showAboutDialog,
                  ),
                  const SizedBox(height: 12),
                  _buildMenuTile(
                    AppLanguage.t('settings_help_support'),
                    '',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpSupportScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _showLogoutDialog,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLanguage.t('profile_logout'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                              fontFamily: 'JosefinSans',
                            ),
                          ),
                          const Icon(
                            Icons.logout,
                            color: Colors.red,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoriesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Select Categories',
          style: TextStyle(fontFamily: 'JosefinSans'),
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _eventCategories.map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return CheckboxListTile(
                    title: Text(category, style: const TextStyle(fontFamily: 'JosefinSans')),
                    value: isSelected,
                    activeColor: AppColors.accent,
                    onChanged: (value) {
                      setDialogState(() {
                        if (value == true) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'JosefinSans'),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: AppColors.accent,
                fontFamily: 'JosefinSans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationsDialog() {
    final locations = ['Algiers', 'Oran', 'Constantine', 'Annaba', 'Blida', 'Setif'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Preferred Locations',
          style: TextStyle(fontFamily: 'JosefinSans'),
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: locations.map((location) {
                  final isSelected = _preferredLocations.contains(location);
                  return CheckboxListTile(
                    title: Text(location, style: const TextStyle(fontFamily: 'JosefinSans')),
                    value: isSelected,
                    activeColor: AppColors.accent,
                    onChanged: (value) {
                      setDialogState(() {
                        if (value == true) {
                          _preferredLocations.add(location);
                        } else {
                          _preferredLocations.remove(location);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'JosefinSans'),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: AppColors.accent,
                fontFamily: 'JosefinSans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontFamily: 'JosefinSans'),
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '1. Data Collection\nWe collect basic usage data to improve your experience in Eventify.',
                style: TextStyle(fontFamily: 'JosefinSans'),
              ),
              SizedBox(height: 8),
              Text(
                '2. Data Usage\nYour data is used only to personalize event recommendations and notifications.',
                style: TextStyle(fontFamily: 'JosefinSans'),
              ),
              SizedBox(height: 8),
              Text(
                '3. Your Control\nYou can manage your notification and event preferences at any time in the app.',
                style: TextStyle(fontFamily: 'JosefinSans'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: AppColors.accent,
                fontFamily: 'JosefinSans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Terms of Service',
          style: TextStyle(fontFamily: 'JosefinSans'),
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '1. Use of Eventify\nEventify helps you discover and manage events for personal use only.',
                style: TextStyle(fontFamily: 'JosefinSans'),
              ),
              SizedBox(height: 8),
              Text(
                '2. Content\nEvent information is provided as-is and may change without notice.',
                style: TextStyle(fontFamily: 'JosefinSans'),
              ),
              SizedBox(height: 8),
              Text(
                '3. Responsibility\nYou are responsible for your account activity and respecting local laws.',
                style: TextStyle(fontFamily: 'JosefinSans'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: AppColors.accent,
                fontFamily: 'JosefinSans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'JosefinSans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'JosefinSans',
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'JosefinSans',
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.accent,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

