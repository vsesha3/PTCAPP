import 'package:flutter/material.dart';
import 'package:svsflutterui/Student.dart';
import 'package:svsflutterui/Parent.dart';
import 'package:svsflutterui/Questions.dart';

class TabbedLayout extends StatefulWidget {
  const TabbedLayout({super.key});

  @override
  State<TabbedLayout> createState() => _TabbedLayoutState();
}

class _TabbedLayoutState extends State<TabbedLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onSurfaceVariant,
                labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                unselectedLabelStyle:
                    Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                        ),
                indicatorColor: Theme.of(context).colorScheme.primary,
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    text: 'Student',
                  ),
                  Tab(
                    text: 'Parent',
                  ),
                  Tab(
                    text: 'Profession',
                  ),
                  Tab(
                    text: 'Questions',
                  ),
                  Tab(
                    text: 'Billing',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              // Student Tab
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: StudentProfile(),
                ),
              ),
              // Parent Tab
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ParentProfile(),
                ),
              ),
              // Profession Tab
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(child: Text('Professional Information')),
                ),
              ),
              // Questions Tab
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Questions(),
                ),
              ),
              // Billing Tab
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(child: Text('Billing Information')),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
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
                    onPressed: () {
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
                    },
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
