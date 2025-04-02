import 'package:flutter/material.dart';
import 'package:svsflutterui/Student.dart';
import 'package:svsflutterui/Parent.dart';
import 'package:svsflutterui/Questions.dart';

class TabbedLayout extends StatefulWidget {
  final TabController tabController;
  final Function(int, bool) onValidationChanged;
  final int selectedIndex;

  const TabbedLayout({
    super.key,
    required this.tabController,
    required this.onValidationChanged,
    required this.selectedIndex,
  });

  @override
  State<TabbedLayout> createState() => _TabbedLayoutState();
}

class _TabbedLayoutState extends State<TabbedLayout> {
  // Add method to collect form data
  Map<String, dynamic> collectFormData() {
    final studentData = _getStudentData();
    final parentData = _getParentData();
    final questionsData = _getQuestionsData();

    return {
      'student': studentData,
      'parent': parentData,
      'questions': questionsData,
    };
  }

  Map<String, dynamic> _getStudentData() {
    // This will be implemented in the Student widget
    return {};
  }

  Map<String, dynamic> _getParentData() {
    // This will be implemented in the Parent widget
    return {};
  }

  Map<String, dynamic> _getQuestionsData() {
    // This will be implemented in the Questions widget
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.tabController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        // Student Tab
        KeepAliveWrapper(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.transparent,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: StudentProfile(
                  onValidationChanged: (isValid) =>
                      widget.onValidationChanged(0, isValid),
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
                child: ParentProfile(
                  onValidationChanged: (isValid) =>
                      widget.onValidationChanged(1, isValid),
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
                child: Questions(
                  onValidationChanged: (isValid) =>
                      widget.onValidationChanged(2, isValid),
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
    );
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
    super.build(context); // Don't forget this!
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
