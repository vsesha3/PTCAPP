import 'package:flutter/material.dart';
import 'package:svsflutterui/tabbed_layout.dart';
import 'package:svsflutterui/Student.dart';
import 'package:svsflutterui/Parent.dart';
import 'package:svsflutterui/Questions.dart';
import 'package:svsflutterui/api_service.dart';
import 'package:flutter/material.dart' show TabBar, TabBarView;

class StudentProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? studentData;

  const StudentProfileScreen({
    super.key,
    this.studentData,
  });

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  late TabController _tabController;
  int _selectedIndex = 0;
  bool _isStudentValid = false;
  bool _isParentValid = false;
  final bool _isProfessionValid = false;
  bool _isQuestionsValid = false;
  final bool _isBillingValid = false;
  bool _isSaved = false;
  final bool _isSaving = false;

  // Form data notifiers
  final _studentData = ValueNotifier<Map<String, dynamic>>({});
  final _parentData = ValueNotifier<Map<String, dynamic>>({});
  final _questionsData = ValueNotifier<Map<String, dynamic>>({});

  bool get _isFormValid =>
      _isStudentValid && _isParentValid && _isQuestionsValid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

    // Initialize form data if studentData is provided
    if (widget.studentData != null) {
      _initializeFormData(widget.studentData!);
    }
  }

  void _initializeFormData(Map<String, dynamic> data) {
    // Initialize student data
    _studentData.value = {
      'name': data['full_name'] ?? '',
      'nickname': data['nickname'] ?? '',
      'school': data['school'] ?? '',
      'other_info': data['other_info'] ?? '',
      'dob': data['date_of_birth'] ?? '',
      'age': data['age'] ?? '',
      'gender': data['gender'] ?? '',
      'branch': data['branch'] ?? '',
      'nationality': data['nationality'] ?? '',
      'photo': data['photograph'] ?? '',
    };

    // Initialize parent data
    _parentData.value = {
      'mother_first_name': data['mother_first_name'] ?? '',
      'mother_contact': data['mother_contact'] ?? '',
      'mother_email': data['mother_email'] ?? '',
      'mother_social_media': data['mother_social_media'] ?? '',
      'mother_profession': data['mother_profession'] ?? '',
      'mother_date_of_birth': data['mother_date_of_birth'] ?? '',
      'mother_age': data['mother_age'] ?? '',
      'mother_photo': data['mother_photo'] ?? '',
      'father_first_name': data['father_first_name'] ?? '',
      'father_contact': data['father_contact'] ?? '',
      'father_email': data['father_email'] ?? '',
      'father_social_media': data['father_social_media'] ?? '',
      'father_profession': data['father_profession'] ?? '',
      'father_date_of_birth': data['father_date_of_birth'] ?? '',
      'father_age': data['father_age'] ?? '',
      'father_photo': data['father_photo'] ?? '',
      'address': data['address'] ?? '',
      'work_address': data['work_address'] ?? '',
      'emergency_contact': data['emergency_contact'] ?? '',
    };

    // Initialize questions data
    _questionsData.value = {
      'source': data['source'] ?? '',
      'others': data['other_source'] ?? '',
    };

    // Set validation states
    _isStudentValid = true;
    _isParentValid = true;
    _isQuestionsValid = true;
    _isSaved = true;
  }

  void _updateValidationState(int tabIndex, bool isValid) {
    setState(() {
      switch (tabIndex) {
        case 0:
          _isStudentValid = isValid;
          break;
        case 1:
          _isParentValid = isValid;
          break;
        case 2: // Questions tab
          _isQuestionsValid = isValid;
          break;
      }
    });
  }

  void _updateStudentData(Map<String, dynamic> data) {
    _studentData.value = data;
  }

  void _updateParentData(Map<String, dynamic> data) {
    _parentData.value = data;
  }

  void _updateQuestionsData(Map<String, dynamic> data) {
    _questionsData.value = data;
  }

  Future<void> _handleSave() async {
    print('=== Starting Save Process ===');

    // Check if form key is valid
    if (_formKey.currentState == null) {
      print('Error: Form state is null');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Form state error. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    print('Form validation state: ${_formKey.currentState?.validate()}');
    print('Student data: ${_studentData.value}');
    print('Parent data: ${_parentData.value}');
    print('Questions data: ${_questionsData.value}');

    if (_formKey.currentState!.validate()) {
      print('Form validation passed');
      try {
        print('Preparing data structure...');

        // Validate required fields
        print('Checking if form data is empty...');
        print('Student data empty: ${_studentData.value.isEmpty}');
        print('Parent data empty: ${_parentData.value.isEmpty}');
        print('Questions data empty: ${_questionsData.value.isEmpty}');

        if (_studentData.value.isEmpty ||
            _parentData.value.isEmpty ||
            _questionsData.value.isEmpty) {
          print('Error: One or more form sections are empty');
          throw Exception('Please fill in all required fields');
        }
        print('Building student data structure...');
        final studentData = {
          'full_name': _studentData.value['name'] ?? '',
          'nickname': _studentData.value['nickname'] ?? '',
          'school': _studentData.value['school'] ?? '',
          'other_info': _studentData.value['other_info'] ?? '',
          'date_of_birth': _studentData.value['dob'] ?? '',
          'age': _studentData.value['age'] ?? '',
          'gender': _studentData.value['gender'] ?? '',
          'branch': _studentData.value['branch'] ?? '',
          'nationality': _studentData.value['nationality'] ?? '',
          'workshops': _studentData.value['workshops'] ?? [],
          'photo': _studentData.value['photo'] ?? ''
        };
        print('Student data structure: $studentData');

        print('Building parent data structure...');
        final parentData = {
          'mother_first_name': _parentData.value['mother_first_name'] ?? '',
          'mother_contact': _parentData.value['mother_contact'] ?? '',
          'mother_email': _parentData.value['mother_email'] ?? '',
          'mother_social_media': _parentData.value['mother_social_media'] ?? '',
          'mother_profession': _parentData.value['mother_profession'] ?? '',
          'mother_date_of_birth':
              _parentData.value['mother_date_of_birth'] ?? '',
          'mother_age': _parentData.value['mother_age'] ?? '',
          'mother_photo': _parentData.value['mother_photo'] ?? '',
          'father_first_name': _parentData.value['father_first_name'] ?? '',
          'father_contact': _parentData.value['father_contact'] ?? '',
          'father_email': _parentData.value['father_email'] ?? '',
          'father_social_media': _parentData.value['father_social_media'] ?? '',
          'father_profession': _parentData.value['father_profession'] ?? '',
          'father_date_of_birth':
              _parentData.value['father_date_of_birth'] ?? '',
          'father_age': _parentData.value['father_age'] ?? '',
          'father_photo': _parentData.value['father_photo'] ?? '',
          'address': _parentData.value['address'] ?? '',
          'work_address': _parentData.value['work_address'] ?? '',
          'emergency_contact': _parentData.value['emergency_contact'] ?? '',
        };
        print('Parent data structure: $parentData');

        print('Building questions data structure...');
        final questionsData = {
          'source': _getSourceString(),
          'other_source': _questionsData.value['others'] ?? '',
        };
        print('Questions data structure: $questionsData');

        // Combine all data
        final data = {
          'student': studentData,
          'parent': parentData,
          'questions': questionsData,
        };
        print('Final data structure: $data');

        // Validate required fields in the structured data
        print('Validating required fields...');

        print('Validating student data...');
        if (studentData['full_name']?.isEmpty ??
            true || studentData['date_of_birth']?.isEmpty ??
            true || studentData['gender']?.isEmpty ??
            true || studentData['branch']?.isEmpty ??
            true || studentData['nationality']?.isEmpty ??
            true) {
          print('Error: Missing required student information');
          throw Exception('Please fill in all required student information');
        }

        print('Validating parent data...');
        if (parentData['mother_first_name']?.isEmpty ??
            true || parentData['mother_contact']?.isEmpty ??
            true || parentData['address']?.isEmpty ??
            true || parentData['emergency_contact']?.isEmpty ??
            true) {
          print('Error: Missing required parent information');
          throw Exception('Please fill in all required parent information');
        }

        print('Validating questions data...');
        if (questionsData['source']?.isEmpty ?? true) {
          print('Error: No source selected');
          throw Exception('Please select at least one source');
        }

        print('All validations passed');

        print('Calling API service...');
        final response = await _apiService.saveStudentData(data);
        print('API response received: $response');

        if (response['success']) {
          print('Save successful');
          if (mounted) {
            setState(() {
              _isSaved = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response['message'] ?? 'Data saved successfully'),
                backgroundColor: Colors.green,
              ),
            );
            // Don't close the popup, just update the state
            // Navigator.of(context).pop();
          }
        } else {
          print('Save failed: ${response['message']}');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response['message'] ?? 'Failed to save data'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e, stackTrace) {
        print('=== Error Occurred ===');
        print('Error message: $e');
        print('Stack trace: $stackTrace');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      print('Form validation failed');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all required fields correctly'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    print('=== Save Process Completed ===');
  }

  String _getSourceString() {
    final sources = <String>[];
    if (_questionsData.value['facebook'] == true) sources.add('Facebook');
    if (_questionsData.value['instagram'] == true) sources.add('Instagram');
    if (_questionsData.value['friend'] == true) sources.add('Friend');
    if (_questionsData.value['website'] == true) sources.add('Website');
    return sources.join(', ');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _studentData.dispose();
    _parentData.dispose();
    _questionsData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                  unselectedLabelStyle:
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                  indicatorColor: Colors.black,
                  indicatorWeight: 3,
                  dividerColor: Colors.transparent,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  splashFactory: NoSplash.splashFactory,
                  tabs: [
                    Tab(text: 'Student'),
                    Tab(text: 'Parent'),
                    Tab(text: 'Questions'),
                    Tab(text: 'Billing'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                // Student Tab
                KeepAliveWrapper(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.transparent,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ValueListenableBuilder<Map<String, dynamic>>(
                          valueListenable: _studentData,
                          builder: (context, data, child) {
                            return StudentProfile(
                              onValidationChanged: (isValid) =>
                                  _updateValidationState(0, isValid),
                              onDataChanged: _updateStudentData,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                // Parent Tab
                KeepAliveWrapper(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.transparent,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ValueListenableBuilder<Map<String, dynamic>>(
                          valueListenable: _parentData,
                          builder: (context, data, child) {
                            return ParentProfile(
                              onValidationChanged: (isValid) =>
                                  _updateValidationState(1, isValid),
                              onDataChanged: _updateParentData,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                // Questions Tab
                KeepAliveWrapper(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.transparent,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ValueListenableBuilder<Map<String, dynamic>>(
                          valueListenable: _questionsData,
                          builder: (context, data, child) {
                            return Questions(
                              onValidationChanged: (isValid) =>
                                  _updateValidationState(2, isValid),
                              onDataChanged: _updateQuestionsData,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                // Billing Tab
                KeepAliveWrapper(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.transparent,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(child: Text('Billing Information')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isFormValid ? _handleSave : null,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: _isFormValid
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                      foregroundColor: _isFormValid
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _isSaved ? 'Update' : 'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
