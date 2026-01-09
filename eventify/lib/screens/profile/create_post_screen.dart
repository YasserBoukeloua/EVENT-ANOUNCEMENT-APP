import 'dart:io';
import 'package:flutter/material.dart';
import 'package:eventify/constants/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/cubits/profile/profile_cubit.dart';
import 'package:eventify/cubits/profile/profile_state.dart';
import 'package:eventify/cubits/events/events_cubit.dart';
import 'package:eventify/data/repo/event/event_repository.dart';
import 'package:eventify/services/notification_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _registrationLinkController = TextEditingController();
  
  DateTime? _selectedDate;
  String _selectedCategory = 'Technology';
  bool _isPaid = false;
  File? _selectedImage;
  bool _isLoading = false;

  final List<String> _categories = [
    'Technology',
    'Business',
    'Education',
    'Music',
    'Sports',
    'Art & Culture',
    'Food & Drink',
    'Health & Wellness',
    'Other',
  ];

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _registrationLinkController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e', isError: true);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryDark,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<String?> _saveImageToAppDirectory(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'event_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final savedImage = await imageFile.copy('${appDir.path}/$fileName');
      return savedImage.path;
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

  bool _isValidUrl(String url) {
    if (url.isEmpty) return true; // Optional field
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _savePost() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      _showSnackBar('Please select a date', isError: true);
      return;
    }

    final profileState = context.read<ProfileCubit>().state;
    if (profileState.user == null) {
      _showSnackBar('You must be logged in to create a post', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Save image if selected
      String? imagePath;
      if (_selectedImage != null) {
        imagePath = await _saveImageToAppDirectory(_selectedImage!);
        if (imagePath == null) {
          _showSnackBar('Failed to save image', isError: true);
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      // Create event
      final repository = EventRepository();
      final eventId = await repository.createEvent(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        date: _selectedDate!,
        location: _locationController.text.trim(),
        category: _selectedCategory,
        publisher: profileState.user!.username,
        isFree: !_isPaid,
        photoPath: imagePath,
        registrationLink: _registrationLinkController.text.trim().isEmpty 
            ? null 
            : _registrationLinkController.text.trim(),
      );

      if (eventId != null) {
        // Trigger notification
        await NotificationService().notifyNewEvent(
          eventId,
          _titleController.text.trim(),
        );

        // Refresh events
        if (mounted) {
          context.read<EventsCubit>().refreshEvents();
        }
        
        _showSnackBar('Event created successfully!');
        
        // Navigate back after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        _showSnackBar('Failed to create event', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error creating event: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMedium,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          'Create Event',
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Field
              _buildSectionLabel('Event Title'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _titleController,
                hint: 'Enter event title',
                icon: Icons.title,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  if (value.length > 100) {
                    return 'Title must be less than 100 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Date Picker
              _buildSectionLabel('Event Date'),
              const SizedBox(height: 8),
              _buildDatePicker(),
              const SizedBox(height: 20),

              // Location Field
              _buildSectionLabel('Location'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _locationController,
                hint: 'Enter event location',
                icon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Location is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Category Dropdown
              _buildSectionLabel('Category'),
              const SizedBox(height: 8),
              _buildCategoryDropdown(),
              const SizedBox(height: 20),

              // Paid/Free Toggle
              _buildSectionLabel('Event Type'),
              const SizedBox(height: 8),
              _buildPaidFreeToggle(),
              const SizedBox(height: 20),

              // Description Field
              _buildSectionLabel('About Event'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _descriptionController,
                hint: 'Describe your event...',
                icon: Icons.description,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  if (value.length > 500) {
                    return 'Description must be less than 500 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Registration Link Field
              _buildSectionLabel('Registration Link (Optional)'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _registrationLinkController,
                hint: 'https://example.com/register',
                icon: Icons.link,
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty && !_isValidUrl(value)) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Image Picker
              _buildSectionLabel('Event Image (Optional)'),
              const SizedBox(height: 8),
              _buildImagePicker(),
              const SizedBox(height: 30),

              // Submit Button
              _buildSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryDark,
        fontFamily: 'JosefinSans',
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontFamily: 'JosefinSans',
          ),
          prefixIcon: Icon(icon, color: AppColors.accent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.accent),
            const SizedBox(width: 12),
            Text(
              _selectedDate == null
                  ? 'Select event date'
                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              style: TextStyle(
                color: _selectedDate == null ? Colors.grey[400] : Colors.black,
                fontFamily: 'JosefinSans',
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.category, color: AppColors.accent),
        ),
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'JosefinSans',
          fontSize: 14,
        ),
        dropdownColor: Colors.white,
        items: _categories.map((category) {
          return DropdownMenuItem(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedCategory = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildPaidFreeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleOption(
              label: 'Free',
              isSelected: !_isPaid,
              onTap: () => setState(() => _isPaid = false),
            ),
          ),
          Expanded(
            child: _buildToggleOption(
              label: 'Paid',
              isSelected: _isPaid,
              onTap: () => setState(() => _isPaid = true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'JosefinSans',
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _selectedImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to select image',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'JosefinSans',
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 20),
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _savePost,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Create Event',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'JosefinSans',
              ),
            ),
    );
  }
}
