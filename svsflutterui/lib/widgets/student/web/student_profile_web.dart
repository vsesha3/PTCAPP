import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ptcmodels/controllers/student_profile_controller.dart';
import '../../../ptcmodels/student_model.dart';
import 'student_profile_edit_web.dart';

class StudentProfileWeb extends StatefulWidget {
  final int? studentId;

  const StudentProfileWeb({Key? key, this.studentId}) : super(key: key);

  @override
  State<StudentProfileWeb> createState() => _StudentProfileWebState();
}

class _StudentProfileWebState extends State<StudentProfileWeb> {
  late StudentProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StudentProfileController();
    if (widget.studentId != null) {
      _controller.loadStudentProfile(widget.studentId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<StudentProfileController>(
        builder: (context, controller, child) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 0,
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.studentId == null
                            ? 'New Student Profile'
                            : 'Student Profile',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                ),
                      ),
                    ),
                    leading: const SizedBox(),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  if (controller.isLoading)
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (controller.hasError)
                    Expanded(
                      child: Center(
                        child: Text(
                          controller.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: StudentProfileEditWeb(
                        studentProfile: controller.studentProfile!,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
