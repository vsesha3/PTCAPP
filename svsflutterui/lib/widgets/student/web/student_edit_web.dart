import 'package:flutter/material.dart';

class StudentEditViewWeb extends StatelessWidget {
  final int? studentId;

  const StudentEditViewWeb({
    super.key,
    this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStepper(
            title: 'Student',
            steps: [
              Step(
                title: const Text('Basic Info'),
                content: Container(),
                isActive: true,
              ),
              Step(
                title: const Text('Additional Info'),
                content: Container(),
                isActive: false,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStepper(
            title: 'Parent Details',
            steps: [
              Step(
                title: const Text('Father'),
                content: Container(),
                isActive: true,
              ),
              Step(
                title: const Text('Mother'),
                content: Container(),
                isActive: false,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStepper(
            title: 'Questions',
            steps: [
              Step(
                title: const Text('Source'),
                content: Container(),
                isActive: true,
              ),
              Step(
                title: const Text('Other Info'),
                content: Container(),
                isActive: false,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStepper(
            title: 'Admission',
            steps: [
              Step(
                title: const Text('Billing'),
                content: Container(),
                isActive: true,
              ),
              Step(
                title: const Text('Confirmation'),
                content: Container(),
                isActive: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepper({
    required String title,
    required List<Step> steps,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Stepper(
            currentStep: 0,
            steps: steps,
            controlsBuilder: (context, details) {
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
