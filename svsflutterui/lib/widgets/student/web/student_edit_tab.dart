import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../ptcmodels/student_model.dart';

class StudentEditTab extends StatelessWidget {
  final StudentModel student;
  final Function(String) onPhotoChanged;

  const StudentEditTab({
    Key? key,
    required this.student,
    required this.onPhotoChanged,
  }) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        onPhotoChanged(base64String);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error picking image')),
        );
      }
    }
  }

  int _calculateAge(String dateOfBirth) {
    try {
      final parts = dateOfBirth.split('-');
      if (parts.length != 3) return 0;

      final year = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final day = int.tryParse(parts[2]);

      if (year == null || month == null || day == null) return 0;

      final birthDate = DateTime(year, month, day);
      final today = DateTime.now();

      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo Section
          Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Stack(
                  children: [
                    if (student.photograph.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.memory(
                          base64Decode(student.photograph),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Center(
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Material(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _pickImage(context),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Student Details Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Full Name Field
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Name',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            initialValue: student.full_name,
                            decoration: const InputDecoration(
                              hintText: 'Enter full name',
                              isDense: true,
                            ),
                            onChanged: (value) {
                              student.full_name = value;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Date of Birth Field
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date of Birth',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            initialValue: student.date_of_birth,
                            decoration: const InputDecoration(
                              hintText: 'YYYY-MM-DD',
                              isDense: true,
                            ),
                            onChanged: (value) {
                              student.date_of_birth = value;
                              student.age = _calculateAge(value);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Age Field
                    SizedBox(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Age',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            initialValue: student.age.toString(),
                            readOnly: true,
                            decoration: const InputDecoration(
                              hintText: 'Auto-calculated',
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
