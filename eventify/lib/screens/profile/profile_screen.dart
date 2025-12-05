import 'package:flutter/material.dart';
import 'package:eventify/localization/app_language.dart';
import 'package:eventify/screens/settings/settings_screen.dart';
import 'package:eventify/screens/login/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = 'Mustapha';
  String _email = 'mustapha@example.com';
  String _mobileNumber = '+213 555 123 456';
  int _userScore = 1250; // User score based on activity
  int _eventsAttended = 12;
  int _eventsCreated = 3;

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _changeProfilePicture() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile picture change feature', style: TextStyle(fontFamily: 'JosefinSans')),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'JosefinSans'),
        ),
        content: const Text('Are you sure you want to logout?', style: TextStyle(fontFamily: 'JosefinSans')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontFamily: 'JosefinSans'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate back to login screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Logged out successfully', style: TextStyle(fontFamily: 'JosefinSans')),
                  backgroundColor: const Color(0xFF6C5CE7),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: const Text(
              'Logout',
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

  void _showEditInfoDialog(String field, String currentValue) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'JosefinSans'),
            ),
          ),
          TextButton(
            onPressed: () {
              final newValue = controller.text.trim();
              if (newValue.isEmpty) {
                Navigator.pop(context);
                return;
              }

              setState(() {
                if (field == 'Username') {
                  _username = newValue;
                } else if (field == 'Email') {
                  _email = newValue;
                } else if (field == 'Mobile Number') {
                  _mobileNumber = newValue;
                }
              });

              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF6C5CE7),
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
      body: Column(
        children: [
          // Header with gradient
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1a0d2e),
                  Color(0xFF2d1b4e),
                ],
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
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
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
                          onPressed: _navigateToSettings,
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
                          onTap: _changeProfilePicture,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 45,
                              color: Color(0xFF2d1b4e),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'JosefinSans',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _email,
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
                            label: 'Score',
                            value: _userScore.toString(),
                            color: Colors.amber,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _buildScoreItem(
                            icon: Icons.event,
                            label: 'Attended',
                            value: _eventsAttended.toString(),
                            color: Colors.green,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _buildScoreItem(
                            icon: Icons.add_circle_outline,
                            label: 'Created',
                            value: _eventsCreated.toString(),
                            color: Colors.blue,
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
                color: Color(0xFFc4b5d6),
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
                    _buildInfoCard('Username', _username, Icons.person_outline),
                    const SizedBox(height: 12),
                    _buildInfoCard('Email', _email, Icons.email_outlined),
                    const SizedBox(height: 12),
                    _buildInfoCard('Mobile Number', _mobileNumber, Icons.phone_outlined),
                    const SizedBox(height: 30),

                    // Activity Section
                    Text(
                      AppLanguage.t('profile_activity'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildActivityCard(
                      icon: Icons.favorite,
                      title: 'Favorites',
                      value: '5',
                      color: Colors.red,
                    ),
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
                    _buildMenuItem('Ad Preferences', Icons.ads_click, () {}),
                    const SizedBox(height: 12),
                    _buildMenuItem('Session Management', Icons.security, () {}),
                    const SizedBox(height: 12),
                    _buildMenuItem('Browser Settings', Icons.browser_updated, () {}),
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
                    _buildMenuItem(AppLanguage.t('profile_logout'), Icons.logout, _showLogoutDialog, isLogout: true),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFb8a5cf),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2d1b4e), size: 24),
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
              color: Color(0xFF2d1b4e),
              size: 22,
            ),
            onPressed: () => _showEditInfoDialog(label, value),
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
        color: const Color(0xFFb8a5cf),
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
          color: isLogout ? Colors.red.shade50 : const Color(0xFFb8a5cf),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isLogout ? Colors.red.shade700 : const Color(0xFF2d1b4e),
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isLogout ? Colors.red.shade700 : Colors.black,
                    fontFamily: 'JosefinSans',
                  ),
                ),
              ],
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
