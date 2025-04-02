import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

class ParentProfile extends StatefulWidget {
  final Function(bool) onValidationChanged;
  final Function(Map<String, dynamic>)? onDataChanged;

  const ParentProfile({
    super.key,
    required this.onValidationChanged,
    this.onDataChanged,
  });

  @override
  State<ParentProfile> createState() => _ParentProfileState();
}

class _ParentProfileState extends State<ParentProfile> {
  final _formKey = GlobalKey<FormState>();
  String? _motherPhotoPath;
  String? _fatherPhotoPath;
  String? _motherPhotoBase64;
  String? _fatherPhotoBase64;
  final ImagePicker _picker = ImagePicker();

  // Mother's Information Controllers
  final _motherFirstNameController = TextEditingController();
  final _motherContactController = TextEditingController();
  final _motherEmailController = TextEditingController();
  final _motherSocialMediaController = TextEditingController();
  final _motherProfessionController = TextEditingController();
  final _motherDateOfBirthController = TextEditingController();
  final _motherAgeController = TextEditingController();
  DateTime? _motherDateOfBirth;

  // Father's Information Controllers
  final _fatherFirstNameController = TextEditingController();
  final _fatherContactController = TextEditingController();
  final _fatherEmailController = TextEditingController();
  final _fatherSocialMediaController = TextEditingController();
  final _fatherProfessionController = TextEditingController();
  final _fatherDateOfBirthController = TextEditingController();
  final _fatherAgeController = TextEditingController();
  DateTime? _fatherDateOfBirth;

  // Common Address Controller
  final _addressController = TextEditingController();
  final _workAddressController = TextEditingController();
  final _emergencyContactController = TextEditingController();

  // JSON data for professions
  final List<Map<String, dynamic>> _professions = [
    {'id': 1, 'name': 'Doctor'},
    {'id': 2, 'name': 'Engineer'},
    {'id': 3, 'name': 'Teacher'},
    {'id': 4, 'name': 'Business Owner'},
    {'id': 5, 'name': 'Accountant'},
    {'id': 6, 'name': 'Lawyer'},
    {'id': 7, 'name': 'IT Professional'},
    {'id': 8, 'name': 'Government Employee'},
    {'id': 9, 'name': 'Artist'},
    {'id': 10, 'name': 'Other'},
  ];

  @override
  void initState() {
    super.initState();
    // Add listeners to all text controllers
    _motherFirstNameController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _motherContactController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _motherEmailController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _motherSocialMediaController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _motherProfessionController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _motherDateOfBirthController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _motherAgeController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _fatherFirstNameController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _fatherContactController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _fatherEmailController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _fatherSocialMediaController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _fatherProfessionController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _fatherDateOfBirthController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _fatherAgeController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _addressController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _workAddressController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _emergencyContactController.addListener(() {
      _validateForm();
      _updateFormData();
    });

    // Initial validation
    _validateForm();
  }

  void _validateForm() {
    if (_formKey.currentState != null) {
      bool isValid = true;

      // Check if at least one parent's name is provided
      if (_motherFirstNameController.text.isEmpty &&
          _fatherFirstNameController.text.isEmpty) {
        isValid = false;
      }

      // Check if at least one address is provided
      if (_addressController.text.isEmpty &&
          _workAddressController.text.isEmpty) {
        isValid = false;
      }

      // Check if at least one contact is provided
      if (_motherContactController.text.isEmpty &&
          _fatherContactController.text.isEmpty) {
        isValid = false;
      }

      // Validate the form state
      isValid = isValid && _formKey.currentState!.validate();

      // Notify parent about validation state
      widget.onValidationChanged(isValid);
    }
  }

  void _calculateAge(
      DateTime dateOfBirth, TextEditingController ageController) {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    ageController.text = age.toString();
  }

  Future<void> _selectDate(BuildContext context, bool isMother) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isMother
          ? (_motherDateOfBirth ?? DateTime.now())
          : (_fatherDateOfBirth ?? DateTime.now()),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null &&
        picked != (isMother ? _motherDateOfBirth : _fatherDateOfBirth)) {
      setState(() {
        if (isMother) {
          _motherDateOfBirth = picked;
          _motherDateOfBirthController.text =
              "${picked.day}/${picked.month}/${picked.year}";
          _calculateAge(picked, _motherAgeController);
        } else {
          _fatherDateOfBirth = picked;
          _fatherDateOfBirthController.text =
              "${picked.day}/${picked.month}/${picked.year}";
          _calculateAge(picked, _fatherAgeController);
        }
      });
    }
  }

  Future<void> _pickImage(bool isMother) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        setState(() {
          if (isMother) {
            _motherPhotoBase64 = base64String;
          } else {
            _fatherPhotoBase64 = base64String;
          }
        });
        _updateFormData();
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _motherFirstNameController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _motherContactController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _motherEmailController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _motherSocialMediaController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _motherProfessionController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _motherDateOfBirthController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _motherAgeController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _fatherFirstNameController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _fatherContactController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _fatherEmailController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _fatherSocialMediaController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _fatherProfessionController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _fatherDateOfBirthController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _fatherAgeController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _addressController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _workAddressController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _emergencyContactController.removeListener(() {
      _validateForm();
      _updateFormData();
    });
    _motherFirstNameController.dispose();
    _motherContactController.dispose();
    _motherEmailController.dispose();
    _motherSocialMediaController.dispose();
    _motherProfessionController.dispose();
    _motherDateOfBirthController.dispose();
    _motherAgeController.dispose();
    _fatherFirstNameController.dispose();
    _fatherContactController.dispose();
    _fatherEmailController.dispose();
    _fatherSocialMediaController.dispose();
    _fatherProfessionController.dispose();
    _fatherDateOfBirthController.dispose();
    _fatherAgeController.dispose();
    _addressController.dispose();
    _workAddressController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  Widget _buildPhotoUploadField({
    required String label,
    required String? photoBase64,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: 'Inter',
                letterSpacing: 0.0,
              ),
        ),
        SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 2,
              ),
            ),
            child: photoBase64 != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.memory(
                      base64Decode(photoBase64),
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Upload Photo',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildMandatoryLabel(String label, bool isRequired) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontFamily: 'Inter',
            letterSpacing: 0.0,
            color: isRequired
                ? Colors.red
                : Theme.of(context).colorScheme.onSurface,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 2,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Parent Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                      ),
                      Text(
                        'Update parent information',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'Inter',
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: Theme.of(context).colorScheme.outline,
                    height: 24,
                  ),
                  // Parent Information Section
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWeb = constraints.maxWidth > 600;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mother's Information Section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mother\'s Information',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildPhotoUploadField(
                                      label: 'Photograph',
                                      photoBase64: _motherPhotoBase64,
                                      onTap: () => _pickImage(true),
                                    ),
                                    SizedBox(width: 24),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildMandatoryLabel(
                                                'Full name',
                                                _fatherFirstNameController
                                                    .text.isEmpty,
                                              ),
                                              SizedBox(height: 4),
                                              TextFormField(
                                                controller:
                                                    _motherFirstNameController,
                                                validator: (value) {
                                                  if (_fatherFirstNameController
                                                          .text.isEmpty &&
                                                      (value == null ||
                                                          value.isEmpty)) {
                                                    return 'Please enter mother\'s name if father\'s name is not provided';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Enter mother\'s name',
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 8),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Date of Birth',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            fontFamily: 'Inter',
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    TextFormField(
                                                      controller:
                                                          _motherDateOfBirthController,
                                                      readOnly: true,
                                                      onTap: () => _selectDate(
                                                          context, true),
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'DD/MM/YYYY',
                                                        suffixIcon: IconButton(
                                                          icon: Icon(Icons
                                                              .calendar_today),
                                                          onPressed: () =>
                                                              _selectDate(
                                                                  context,
                                                                  true),
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        8),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .outline,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Age',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            fontFamily: 'Inter',
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    TextFormField(
                                                      controller:
                                                          _motherAgeController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Enter age',
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        8),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .outline,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
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
                                SizedBox(height: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildMandatoryLabel(
                                      'Contact',
                                      _fatherContactController.text.isEmpty,
                                    ),
                                    SizedBox(height: 4),
                                    TextFormField(
                                      controller: _motherContactController,
                                      validator: (value) {
                                        if (_fatherContactController
                                                .text.isEmpty &&
                                            (value == null || value.isEmpty)) {
                                          return 'Please enter mother\'s contact if father\'s contact is not provided';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Enter contact number',
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    SizedBox(height: 4),
                                    TextFormField(
                                      controller: _motherEmailController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter email address',
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (isWeb) SizedBox(width: 32),
                          // Father's Information Section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Father\'s Information',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildPhotoUploadField(
                                      label: 'Photograph',
                                      photoBase64: _fatherPhotoBase64,
                                      onTap: () => _pickImage(false),
                                    ),
                                    SizedBox(width: 24),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildMandatoryLabel(
                                                'Full name',
                                                _motherFirstNameController
                                                    .text.isEmpty,
                                              ),
                                              SizedBox(height: 4),
                                              TextFormField(
                                                controller:
                                                    _fatherFirstNameController,
                                                validator: (value) {
                                                  if (_motherFirstNameController
                                                          .text.isEmpty &&
                                                      (value == null ||
                                                          value.isEmpty)) {
                                                    return 'Please enter father\'s name if mother\'s name is not provided';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Enter father\'s name',
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 8),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Date of Birth',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            fontFamily: 'Inter',
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    TextFormField(
                                                      controller:
                                                          _fatherDateOfBirthController,
                                                      readOnly: true,
                                                      onTap: () => _selectDate(
                                                          context, false),
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'DD/MM/YYYY',
                                                        suffixIcon: IconButton(
                                                          icon: Icon(Icons
                                                              .calendar_today),
                                                          onPressed: () =>
                                                              _selectDate(
                                                                  context,
                                                                  false),
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        8),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .outline,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Age',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            fontFamily: 'Inter',
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    TextFormField(
                                                      controller:
                                                          _fatherAgeController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Enter age',
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        8),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .outline,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
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
                                SizedBox(height: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildMandatoryLabel(
                                      'Contact',
                                      _motherContactController.text.isEmpty,
                                    ),
                                    SizedBox(height: 4),
                                    TextFormField(
                                      controller: _fatherContactController,
                                      validator: (value) {
                                        if (_motherContactController
                                                .text.isEmpty &&
                                            (value == null || value.isEmpty)) {
                                          return 'Please enter father\'s contact if mother\'s contact is not provided';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Enter contact number',
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    SizedBox(height: 4),
                                    TextFormField(
                                      controller: _fatherEmailController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter email address',
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 24),
                  // Common Address Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Address for Communication',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMandatoryLabel(
                              'Home Address',
                              _workAddressController.text.isEmpty,
                            ),
                            SizedBox(height: 4),
                            TextFormField(
                              controller: _addressController,
                              validator: (value) {
                                if (_workAddressController.text.isEmpty &&
                                    (value == null || value.isEmpty)) {
                                  return 'Please enter home address if work address is not provided';
                                }
                                return null;
                              },
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Enter home address',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMandatoryLabel(
                              'Work Address',
                              _addressController.text.isEmpty,
                            ),
                            SizedBox(height: 4),
                            TextFormField(
                              controller: _workAddressController,
                              validator: (value) {
                                if (_addressController.text.isEmpty &&
                                    (value == null || value.isEmpty)) {
                                  return 'Please enter work address if home address is not provided';
                                }
                                return null;
                              },
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Enter work address',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Emergency Contact',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            SizedBox(height: 4),
                            TextFormField(
                              controller: _emergencyContactController,
                              decoration: InputDecoration(
                                hintText: 'Enter emergency contact number',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
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
          ),
        ),
      ),
    );
  }

  void _updateFormData() {
    if (widget.onDataChanged != null) {
      widget.onDataChanged!({
        'mother_first_name': _motherFirstNameController.text,
        'mother_contact': _motherContactController.text,
        'mother_email': _motherEmailController.text,
        'mother_social_media': _motherSocialMediaController.text,
        'mother_profession': _motherProfessionController.text,
        'mother_date_of_birth': _motherDateOfBirthController.text,
        'mother_age': _motherAgeController.text,
        'mother_photo': _motherPhotoBase64,
        'father_first_name': _fatherFirstNameController.text,
        'father_contact': _fatherContactController.text,
        'father_email': _fatherEmailController.text,
        'father_social_media': _fatherSocialMediaController.text,
        'father_profession': _fatherProfessionController.text,
        'father_date_of_birth': _fatherDateOfBirthController.text,
        'father_age': _fatherAgeController.text,
        'father_photo': _fatherPhotoBase64,
        'address': _addressController.text,
        'work_address': _workAddressController.text,
        'emergency_contact': _emergencyContactController.text,
      });
    }
  }
}
