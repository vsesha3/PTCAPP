import 'package:flutter/material.dart';
import 'package:svsflutterui/tabbed_layout.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  bool _isStudentValid = false;
  bool _isParentValid = false;
  final bool _isProfessionValid = false;
  bool _isQuestionsValid = false;
  final bool _isBillingValid = false;

  bool get _isFormValid =>
      _isStudentValid && _isParentValid && _isQuestionsValid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
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
        case 3: // Questions tab
          _isQuestionsValid = isValid;
          break;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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
              Tab(text: 'Profession'),
              Tab(text: 'Questions'),
              Tab(text: 'Billing'),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          TabbedLayout(
            tabController: _tabController,
            onValidationChanged: _updateValidationState,
            selectedIndex: _selectedIndex,
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
                    onPressed: _isFormValid
                        ? () {
                            // Handle save based on current tab
                            switch (_selectedIndex) {
                              case 0: // Student tab
                                // Trigger student form validation
                                break;
                              case 1: // Parent tab
                                // Trigger parent form validation
                                break;
                              // Add cases for other tabs
                            }
                            // Show success notification
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Profile saved successfully!'),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(16),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      disabledForegroundColor: Colors.grey[600],
                    ),
                    child: Text('Save'),
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
