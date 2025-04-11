import 'package:flutter/material.dart';
import 'package:svsflutterui/tabbed_layout.dart';
import 'package:svsflutterui/Student.dart';
import 'package:svsflutterui/Parent.dart';
import 'package:svsflutterui/Questions.dart';
import 'package:svsflutterui/services/api_service.dart';

class StudentProfileScreen extends StatefulWidget {
  final int? studentId;

  const StudentProfileScreen({
    super.key,
    this.studentId,
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
  bool _isLoading = true;

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

    // Fetch student data if ID is provided
    if (widget.studentId != null) {
      _fetchStudentData();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _fetchStudentData() async {
    try {
      final response = await _apiService.getStudentDetails(widget.studentId!);
      if (response['status'] == 200 && response['data'] != null) {
        _initializeFormData(response['data']);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  response['message'] ?? 'Failed to fetch student details'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching student details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _initializeFormData(Map<String, dynamic> data) {
    print('Initializing form data: $data'); // Debug print

    // Initialize student data
    _studentData.value = {
      'name': data['full_name'] ?? '',
      'nickname': data['nickname'] ?? '',
      'school': data['school'] ?? '',
      'other_info': data['other_info'] ?? '',
      'dob': data['date_of_birth'] ?? '',
      'age': data['age']?.toString() ?? '',
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
      'mother_age': data['mother_age']?.toString() ?? '',
      'mother_photo': data['mother_photo'] ?? '',
      'father_first_name': data['father_first_name'] ?? '',
      'father_contact': data['father_contact'] ?? '',
      'father_email': data['father_email'] ?? '',
      'father_social_media': data['father_social_media'] ?? '',
      'father_profession': data['father_profession'] ?? '',
      'father_date_of_birth': data['father_date_of_birth'] ?? '',
      'father_age': data['father_age']?.toString() ?? '',
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
        preferredSize: Size.fromHeight(48),
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : MediaQuery.of(context).size.width >= 1024
              ? Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 1200),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                            child: ValueListenableBuilder<
                                                Map<String, dynamic>>(
                                              valueListenable: _studentData,
                                              builder: (context, data, child) {
                                                return StudentProfile(
                                                  onValidationChanged:
                                                      (isValid) =>
                                                          _updateValidationState(
                                                              0, isValid),
                                                  onDataChanged:
                                                      _updateStudentData,
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                            child: ValueListenableBuilder<
                                                Map<String, dynamic>>(
                                              valueListenable: _parentData,
                                              builder: (context, data, child) {
                                                return ParentProfile(
                                                  onValidationChanged:
                                                      (isValid) =>
                                                          _updateValidationState(
                                                              1, isValid),
                                                  onDataChanged:
                                                      _updateParentData,
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                            child: ValueListenableBuilder<
                                                Map<String, dynamic>>(
                                              valueListenable: _questionsData,
                                              builder: (context, data, child) {
                                                return Questions(
                                                  onValidationChanged:
                                                      (isValid) =>
                                                          _updateValidationState(
                                                              2, isValid),
                                                  onDataChanged:
                                                      _updateQuestionsData,
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                            child: Center(
                                                child: Text(
                                                    'Billing Information')),
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
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[200],
                                    foregroundColor: Colors.grey[800],
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Text('Cancel'),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _handleSave,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Text('Save'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          _buildAccordionItem(0, 'Student Information', [
                            Container(
                              width: 120,
                              height: 120,
                              margin: EdgeInsets.only(top: 16),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: _buildTextField(
                                label: 'Full Name',
                                hint: 'Enter student\'s full name',
                                icon: Icons.person_outline,
                              ),
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: _buildTextField(
                                label: 'Nickname',
                                hint: 'Enter student\'s nickname',
                                icon: Icons.person_outline,
                              ),
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: _buildTextField(
                                label: 'Date of Birth',
                                hint: 'Select date of birth',
                                icon: Icons.calendar_today,
                                isDatePicker: true,
                              ),
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: _buildDropdownField(
                                label: 'Gender',
                                hint: 'Select gender',
                                items: ['Male', 'Female', 'Other'],
                                icon: Icons.person_outline,
                              ),
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: _buildTextField(
                                label: 'School',
                                hint: 'Enter school name',
                                icon: Icons.school,
                              ),
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: _buildTextField(
                                label: 'Branch',
                                hint: 'Enter branch name',
                                icon: Icons.location_on,
                              ),
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: _buildTextField(
                                label: 'Nationality',
                                hint: 'Enter nationality',
                                icon: Icons.flag,
                              ),
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: _buildTextField(
                                label: 'Other Information',
                                hint: 'Enter any additional information',
                                icon: Icons.info_outline,
                              ),
                            ),
                          ]),
                          _buildAccordionItem(1, 'Parent Information', []),
                          _buildAccordionItem(2, 'Questions', []),
                          _buildAccordionItem(3, 'Billing Information', []),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                foregroundColor: Colors.grey[800],
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Text('Cancel'),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _handleSave,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    bool isDatePicker = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(),
            prefixIcon: Icon(icon),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required List<String> items,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          alignment: Alignment.centerLeft,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(),
            prefixIcon: Icon(icon),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                textAlign: TextAlign.left,
              ),
            );
          }).toList(),
          onChanged: (value) {
            // Handle dropdown value change
          },
        ),
      ],
    );
  }

  Widget _buildAccordionItem(int index, String title, List<Widget> content) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
          ),
          child: Material(
            color: _selectedIndex == index
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.white,
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                  _tabController.animateTo(index);
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      _getIconForIndex(index),
                      color: _selectedIndex == index
                          ? Theme.of(context).primaryColor
                          : Colors.grey[600],
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text(
                      title,
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey[800],
                        fontWeight: _selectedIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_selectedIndex == index)
          Container(
            color: Colors.white,
            child: Column(
              children: content,
            ),
          ),
      ],
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.person_outline;
      case 1:
        return Icons.family_restroom;
      case 2:
        return Icons.question_answer;
      case 3:
        return Icons.payment;
      default:
        return Icons.info;
    }
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({
    super.key,
    required this.child,
  });

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
