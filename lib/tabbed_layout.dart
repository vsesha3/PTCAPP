import 'package:flutter/material.dart';
import 'package:svsflutterui/Student.dart';
import 'package:svsflutterui/Parent.dart';
import 'package:svsflutterui/Questions.dart';

class TabbedLayout extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
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
                      onValidationChanged(0, isValid),
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
                      onValidationChanged(1, isValid),
                ),
              ),
            ),
          ),
        ),
        // Profession Tab
        KeepAliveWrapper(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.transparent,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(child: Text('Professional Information')),
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
                      onValidationChanged(3, isValid),
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
