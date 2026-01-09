import 'package:flutter/material.dart';
import 'package:eventify/constants/app_colors.dart';

class VerificationFormScreen extends StatefulWidget {
  const VerificationFormScreen({Key? key}) : super(key: key);

  @override
  State<VerificationFormScreen> createState() => _VerificationFormScreenState();
}

class _VerificationFormScreenState extends State<VerificationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _idNumberController = TextEditingController();
  
  String _selectedIdType = 'National ID';
  final List<String> _idTypes = ['National ID', 'Passport', 'Driver License'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  void _submitVerification() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement actual verification submission logic
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Verification Submitted',
            style: TextStyle(fontFamily: 'JosefinSans'),
          ),
          content: const Text(
            'Your verification request has been submitted. We will review your information and get back to you within 2-3 business days.',
            style: TextStyle(fontFamily: 'JosefinSans'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to verification details
              },
              child: const Text(
                'OK',
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
                    const Text(
                      'Verification Form',
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

          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Full Name Field
                    _buildTextField(
                      controller: _fullNameController,
                      label: 'Full Name',
                      hint: 'Enter your full legal name',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone Number Field
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      hint: 'Enter your phone number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Address Field
                    _buildTextField(
                      controller: _addressController,
                      label: 'Address',
                      hint: 'Enter your full address',
                      icon: Icons.location_on_outlined,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // ID Information Section
                    const Text(
                      'ID Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                    const SizedBox(height: 15),

                    // ID Type Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedIdType,
                        decoration: const InputDecoration(
                          labelText: 'ID Type',
                          border: InputBorder.none,
                          icon: Icon(Icons.badge_outlined, color: AppColors.primaryDark),
                        ),
                        items: _idTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type,
                              style: const TextStyle(fontFamily: 'JosefinSans'),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedIdType = newValue;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ID Number Field
                    _buildTextField(
                      controller: _idNumberController,
                      label: 'ID Number',
                      hint: 'Enter your ID number',
                      icon: Icons.credit_card_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your ID number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Document Upload Section
                    const Text(
                      'Document Upload',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                    const SizedBox(height: 15),

                    _buildUploadButton(
                      'Upload ID Document',
                      Icons.upload_file,
                      () {
                        // TODO: Implement file upload
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'File upload functionality coming soon',
                              style: TextStyle(fontFamily: 'JosefinSans'),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildUploadButton(
                      'Upload Proof of Address',
                      Icons.upload_file,
                      () {
                        // TODO: Implement file upload
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'File upload functionality coming soon',
                              style: TextStyle(fontFamily: 'JosefinSans'),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitVerification,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Submit Verification',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'JosefinSans',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
          icon: Icon(icon, color: AppColors.primaryDark),
          hintStyle: const TextStyle(fontFamily: 'JosefinSans'),
          labelStyle: const TextStyle(fontFamily: 'JosefinSans'),
        ),
        style: const TextStyle(fontFamily: 'JosefinSans'),
      ),
    );
  }

  Widget _buildUploadButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryDark, width: 2, style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryDark),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
                fontFamily: 'JosefinSans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
