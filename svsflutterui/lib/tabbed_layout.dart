import 'package:flutter/material.dart';
import 'package:svsflutterui/Student.dart';
import 'package:svsflutterui/Parent.dart';
import 'package:svsflutterui/Questions.dart';
import 'package:svsflutterui/services/api_service.dart';

class TabbedLayout extends StatefulWidget {
  final int? studentId;
  final VoidCallback? onSave;

  const TabbedLayout({
    super.key,
    this.studentId,
    this.onSave,
  });

  @override
  State<TabbedLayout> createState() => _TabbedLayoutState();
}

class _TabbedLayoutState extends State<TabbedLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  bool _isStudentValid = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Student'),
                Tab(text: 'Parent'),
                Tab(text: 'Questions'),
                Tab(text: 'Billing'),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
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
                              builder: (context, studentData, _) {
                                return StudentProfile(
                                  initialData: studentData,
                                  onValidationChanged: (isValid) =>
                                      _updateValidationState(0, isValid),
                                  onDataChanged: (data) {
                                    _studentData.value = {
                                      ..._studentData.value,
                                      ...data,
                                    };
                                  },
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
                              builder: (context, parentData, _) {
                                return ParentProfile(
                                  onValidationChanged: (isValid) =>
                                      _updateValidationState(1, isValid),
                                  onDataChanged: (data) {
                                    _parentData.value = {
                                      ..._parentData.value,
                                      ...data,
                                    };
                                  },
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
                              builder: (context, questionsData, _) {
                                return Questions(
                                  onValidationChanged: (isValid) =>
                                      _updateValidationState(2, isValid),
                                  onDataChanged: (data) {
                                    _questionsData.value = {
                                      ..._questionsData.value,
                                      ...data,
                                    };
                                  },
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
                        onPressed: () {
                          // Handle save
                          if (widget.onSave != null) {
                            widget.onSave!();
                          }
                          Navigator.pop(context);
                        },
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
        ),
      ),
    );
  }

  bool _isParentValid = false;
  bool _isQuestionsValid = false;
  bool _isLoading = true;
  final _apiService = ApiService();
  final _studentData = ValueNotifier<Map<String, dynamic>>({});
  final _parentData = ValueNotifier<Map<String, dynamic>>({});
  final _questionsData = ValueNotifier<Map<String, dynamic>>({});

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        case 2:
          _isQuestionsValid = isValid;
          break;
      }
    });
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({
    Key? key,
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
