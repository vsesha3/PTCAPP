import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StudentProfile extends StatefulWidget {
  final Function(bool) onValidationChanged;
  final Function(Map<String, dynamic>)? onDataChanged;

  const StudentProfile({
    super.key,
    required this.onValidationChanged,
    this.onDataChanged,
  });

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final _formKey = GlobalKey<FormState>();
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();
  final _textController3 = TextEditingController();
  final _textController4 = TextEditingController();
  final _nickNameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _otherInfoController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = 'Male';
  DateTime? _selectedDate;
  String _selectedBranch = 'Bakhundole';
  String? _photoBase64;
  final ImagePicker _picker = ImagePicker();

  // Workshop selection states
  final Map<String, bool> _workshopSelections = {
    'Basic Grooming Workshop': false,
    'Advanced Grooming Workshop': false,
    'Pet Styling Workshop': false,
    'Pet Care Workshop': false,
    'Business Management Workshop': false,
  };

  // Workshop data loading states
  List<Map<String, dynamic>> _workshopOptions = [];
  String? _selectedWorkshop;
  bool _isLoadingWorkshops = true;

  // Nationality states
  List<String> _nationalities = [];
  String? _selectedNationality;
  bool _isLoadingNationalities = true;

  // Getter for selected workshops
  List<String> get selectedWorkshops => _workshopSelections.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();

  // Getter for display text
  String get workshopDisplayText {
    if (selectedWorkshops.isEmpty) return 'Select workshops';
    if (selectedWorkshops.length == 1) return selectedWorkshops.first;
    return '${selectedWorkshops.length} workshops selected';
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to all text controllers
    _textController1.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _textController2.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _textController3.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _textController4.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _nickNameController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _schoolController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _otherInfoController.addListener(() {
      _validateForm();
      _updateFormData();
    });
    _ageController.addListener(() {
      _validateForm();
      _updateFormData();
    });

    // Load workshop data
    _loadWorkshopData();
    // Load nationality data
    _loadNationalityData();

    // Initial validation
    _validateForm();
  }

  Future<void> _loadWorkshopData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/workshop_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _workshopOptions =
            List<Map<String, dynamic>>.from(jsonData['workshops']);
        if (_workshopOptions.isNotEmpty) {
          _selectedWorkshop = _workshopOptions[0]['id'];
        }
        _isLoadingWorkshops = false;
      });
    } catch (e) {
      print('Error loading workshop data: $e');
      setState(() {
        _isLoadingWorkshops = false;
      });
    }
  }

  Future<void> _loadNationalityData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/nationality_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _nationalities = List<String>.from(jsonData['nationalities']);
        _isLoadingNationalities = false;
      });
      print('Loaded nationalities: $_nationalities'); // Debug print
    } catch (e) {
      print('Error loading nationality data: $e');
      setState(() {
        _nationalities = [
          'Nepali',
          'Indian',
          'Chinese',
          'Japanese',
          'Korean',
          'Thai',
          'Vietnamese',
          'Malaysian',
          'Indonesian',
          'Filipino',
          'Bangladeshi',
          'Sri Lankan',
          'Pakistani',
          'Afghan',
          'Iranian',
          'Iraqi',
          'Saudi Arabian',
          'Emirati',
          'Qatari',
          'Kuwaiti',
          'Bahraini',
          'Omani',
          'Yemeni',
          'Egyptian',
          'Moroccan',
          'Algerian',
          'Tunisian',
          'Libyan',
          'Sudanese',
          'Ethiopian',
          'Kenyan',
          'South African',
          'Nigerian',
          'Ghanaian',
          'British',
          'French',
          'German',
          'Italian',
          'Spanish',
          'Portuguese',
          'Dutch',
          'Belgian',
          'Swiss',
          'Swedish',
          'Norwegian',
          'Danish',
          'Finnish',
          'Russian',
          'Ukrainian',
          'Polish',
          'Czech',
          'Hungarian',
          'Romanian',
          'Bulgarian',
          'Greek',
          'Turkish',
          'American',
          'Canadian',
          'Mexican',
          'Brazilian',
          'Argentine',
          'Chilean',
          'Peruvian',
          'Colombian',
          'Venezuelan',
          'Australian',
          'New Zealander',
          'Other'
        ];
        _isLoadingNationalities = false;
      });
    }
  }

  void _validateForm() {
    if (_formKey.currentState != null) {
      bool isValid = true;

      // Check if full name is provided
      if (_textController1.text.isEmpty) {
        isValid = false;
      }

      // Check if date of birth is provided
      if (_textController3.text.isEmpty) {
        isValid = false;
      }

      // Check if gender is selected
      if (_selectedGender.isEmpty) {
        isValid = false;
      }

      // Check if branch is selected
      if (_selectedBranch.isEmpty) {
        isValid = false;
      }

      // Check if nationality is selected
      if (_selectedNationality == null) {
        isValid = false;
      }

      // Check if at least one workshop is selected
      if (selectedWorkshops.isEmpty) {
        isValid = false;
      }

      // Validate the form state
      isValid = isValid && _formKey.currentState!.validate();

      // Call the validation callback
      widget.onValidationChanged(isValid);
    }
  }

  void _calculateAge(DateTime dateOfBirth) {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    _ageController.text = age.toString();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _textController3.text =
            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
        _calculateAge(picked);
      });
      _validateForm();
    }
  }

  Future<void> _pickImage() async {
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
          _photoBase64 = base64String;
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

  void _updateFormData() {
    if (widget.onDataChanged != null) {
      widget.onDataChanged!({
        'name': _textController1.text,
        'dob': _textController3.text,
        'gender': _selectedGender,
        'nationality': _selectedNationality,
        'workshops': selectedWorkshops,
        'branch': _selectedBranch,
        'nickname': _nickNameController.text,
        'school': _schoolController.text,
        'other_info': _otherInfoController.text,
        'age': _ageController.text,
        'photo': _photoBase64,
      });
    }
  }

  @override
  void dispose() {
    _textController1.removeListener(_validateForm);
    _textController2.removeListener(_validateForm);
    _textController3.removeListener(_validateForm);
    _textController4.removeListener(_validateForm);
    _nickNameController.removeListener(_validateForm);
    _schoolController.removeListener(_validateForm);
    _otherInfoController.removeListener(_validateForm);
    _ageController.removeListener(_validateForm);
    _textController1.dispose();
    _textController2.dispose();
    _textController3.dispose();
    _textController4.dispose();
    _nickNameController.dispose();
    _schoolController.dispose();
    _otherInfoController.dispose();
    _ageController.dispose();
    super.dispose();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Student Profile',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                      ),
                      Text(
                        'Please fill in the following information',
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Photo Upload Column
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                              width: 2,
                            ),
                          ),
                          child: _photoBase64 != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.memory(
                                    base64Decode(_photoBase64!),
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.add_a_photo,
                                        size: 32,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Text(
                                        'Upload Photo',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontFamily: 'Inter',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(width: 16),
                      // Name Fields Column
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Full Name *',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                      ),
                                      SizedBox(height: 4),
                                      TextFormField(
                                        controller: _textController1,
                                        decoration: InputDecoration(
                                          hintText: 'Enter your full name',
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
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your full name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Birth Date *',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                      ),
                                      SizedBox(height: 4),
                                      TextFormField(
                                        controller: _textController3,
                                        readOnly: true,
                                        onTap: () => _selectDate(context),
                                        decoration: InputDecoration(
                                          hintText: 'DD-MM-YYYY',
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          suffixIcon:
                                              Icon(Icons.calendar_today),
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
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  flex: 1,
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
                                        controller: _ageController,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          hintText: 'Age will be calculated',
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
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Gender *',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                      ),
                                      SizedBox(height: 4),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: RadioListTile<String>(
                                                title: Text('Male'),
                                                value: 'Male',
                                                groupValue: _selectedGender,
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    setState(() {
                                                      _selectedGender = value;
                                                      _textController4.text =
                                                          value;
                                                    });
                                                    _validateForm();
                                                  }
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: RadioListTile<String>(
                                                title: Text('Female'),
                                                value: 'Female',
                                                groupValue: _selectedGender,
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    setState(() {
                                                      _selectedGender = value;
                                                      _textController4.text =
                                                          value;
                                                    });
                                                    _validateForm();
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 8, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Nick Name',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 4, 0, 0),
                                          child: TextFormField(
                                            controller: _nickNameController,
                                            decoration: InputDecoration(
                                              hintText: 'Enter nick name',
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Which branch of Grooming tales are you joining? *',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                              ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 4, 0, 0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: RadioListTile<String>(
                                                    title: Text(
                                                        'Grooming tales, Bakhundole, Lalitpur'),
                                                    value: 'Bakhundole',
                                                    groupValue: _selectedBranch,
                                                    onChanged: (value) {
                                                      if (value != null) {
                                                        setState(() {
                                                          _selectedBranch =
                                                              value;
                                                        });
                                                        _validateForm();
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: RadioListTile<String>(
                                                    title: Text(
                                                        'Grooming tales, Gairidhara, Kathmandu'),
                                                    value: 'Gairidhara',
                                                    groupValue: _selectedBranch,
                                                    onChanged: (value) {
                                                      if (value != null) {
                                                        setState(() {
                                                          _selectedBranch =
                                                              value;
                                                        });
                                                        _validateForm();
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Other Information',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 4, 0, 0),
                                  child: TextFormField(
                                    controller: _otherInfoController,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      hintText:
                                          'Enter any additional information',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Workshops you want to join? *',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontFamily: 'Inter',
                                      letterSpacing: 0.0,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                child: PopupMenuButton<String>(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          workshopDisplayText,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                  itemBuilder: (BuildContext context) {
                                    return _workshopSelections.entries
                                        .map((entry) {
                                      return PopupMenuItem<String>(
                                        value: entry.key,
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              value: entry.value,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  _workshopSelections[entry
                                                      .key] = value ?? false;
                                                });
                                                _validateForm();
                                              },
                                            ),
                                            SizedBox(width: 8),
                                            Text(entry.key),
                                          ],
                                        ),
                                      );
                                    }).toList();
                                  },
                                  onSelected: (String value) {
                                    // Handle selection if needed
                                  },
                                ),
                              ),
                              if (selectedWorkshops.isEmpty)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 4, 0, 0),
                                  child: Text(
                                    'Please select at least one workshop',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nationality *',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontFamily: 'Inter',
                                      letterSpacing: 0.0,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedNationality,
                                      isExpanded: true,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      hint: Text('Select nationality'),
                                      items: _nationalities
                                          .map((String nationality) {
                                        return DropdownMenuItem<String>(
                                          value: nationality,
                                          child: Text(nationality),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedNationality = newValue;
                                        });
                                        _validateForm();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
