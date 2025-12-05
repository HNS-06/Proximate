import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/glow_button.dart';

/// Profile setup screen
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Profile', style: TextStyle(fontFamily: 'Monospace')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Your Profile',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Monospace',
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: const TextStyle(color: Colors.green),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(color: Colors.green, fontFamily: 'Monospace'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
                labelStyle: const TextStyle(color: Colors.green),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(color: Colors.green, fontFamily: 'Monospace'),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: GlowButton(
                label: 'Save Profile',
                onPressed: () {
                  if (_nameController.text.isEmpty || _bioController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please fill all fields',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  // Show success and clear fields
                  Get.snackbar(
                    'Success',
                    'Profile saved successfully!',
                    backgroundColor: Colors.black,
                    colorText: Colors.green,
                    duration: const Duration(seconds: 2),
                  );
                  // Clear the form for next entry
                  _nameController.clear();
                  _bioController.clear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
