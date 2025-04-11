import 'package:flutter/material.dart';
import 'package:svsflutterui/ptcmodels/student_model.dart';
import 'student_edit_tab.dart';

class StudentProfileEditWeb extends StatefulWidget {
  final int? studentId;
  final StudentProfileModel studentProfile;

  const StudentProfileEditWeb({
    super.key,
    this.studentId,
    required this.studentProfile,
  });

  @override
  State<StudentProfileEditWeb> createState() => _StudentProfileEditWebState();
}

class _StudentProfileEditWebState extends State<StudentProfileEditWeb>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late StudentProfileModel _studentProfile;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _studentProfile = widget.studentProfile;
  }

  void _updateStudentPhoto(String base64Image) {
    setState(() {
      _studentProfile = StudentProfileModel(
        id: _studentProfile.id,
        student: StudentModel(
          full_name: _studentProfile.student.full_name,
          nickname: _studentProfile.student.nickname,
          school: _studentProfile.student.school,
          other_info: _studentProfile.student.other_info,
          date_of_birth: _studentProfile.student.date_of_birth,
          age: _studentProfile.student.age,
          gender: _studentProfile.student.gender,
          branch: _studentProfile.student.branch,
          nationality: _studentProfile.student.nationality,
          photograph: base64Image,
        ),
        parent: _studentProfile.parent,
        address: _studentProfile.address,
        source: _studentProfile.source,
        other_source: _studentProfile.other_source,
        created_at: _studentProfile.created_at,
        updated_at: _studentProfile.updated_at,
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: 'Student'),
            Tab(text: 'Parent Details'),
            Tab(text: 'Questions'),
            Tab(text: 'Admission'),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              StudentEditTab(
                student: _studentProfile.student,
                onPhotoChanged: _updateStudentPhoto,
              ),
              _buildParentTab(),
              _buildQuestionsTab(),
              _buildAdmissionTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStudentTab() {
    return StudentEditTab(
      student: widget.studentProfile.student,
      onPhotoChanged: (String base64Image) {
        // TODO: Update the student profile with the new photo
        // This will be implemented when we add the update functionality
      },
    );
  }

  Widget _buildParentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Father Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
              'Name', widget.studentProfile.parent.father_first_name),
          _buildDetailRow('Photo', widget.studentProfile.parent.father_photo),
          _buildDetailRow(
              'Contact', widget.studentProfile.parent.father_contact),
          _buildDetailRow('Email', widget.studentProfile.parent.father_email),
          _buildDetailRow(
              'Social Media', widget.studentProfile.parent.father_social_media),
          _buildDetailRow(
              'Profession', widget.studentProfile.parent.father_profession),
          _buildDetailRow('Date of Birth',
              widget.studentProfile.parent.father_date_of_birth),
          _buildDetailRow(
              'Age', widget.studentProfile.parent.father_age.toString()),
          const SizedBox(height: 24),
          const Text(
            'Mother Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
              'Name', widget.studentProfile.parent.mother_first_name),
          _buildDetailRow('Photo', widget.studentProfile.parent.mother_photo),
          _buildDetailRow(
              'Contact', widget.studentProfile.parent.mother_contact),
          _buildDetailRow('Email', widget.studentProfile.parent.mother_email),
          _buildDetailRow(
              'Social Media', widget.studentProfile.parent.mother_social_media),
          _buildDetailRow(
              'Profession', widget.studentProfile.parent.mother_profession),
          _buildDetailRow('Date of Birth',
              widget.studentProfile.parent.mother_date_of_birth),
          _buildDetailRow(
              'Age', widget.studentProfile.parent.mother_age.toString()),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value.isEmpty ? '-' : value),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsTab() {
    return const Center(child: Text('Questions'));
  }

  Widget _buildAdmissionTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Source: ${widget.studentProfile.source}'),
          const SizedBox(height: 8),
          Text('Other Source: ${widget.studentProfile.other_source}'),
          const SizedBox(height: 8),
          Text('Address: ${widget.studentProfile.address.address}'),
          const SizedBox(height: 8),
          Text('Work Address: ${widget.studentProfile.address.work_address}'),
          const SizedBox(height: 8),
          Text(
              'Emergency Contact: ${widget.studentProfile.address.emergency_contact}'),
        ],
      ),
    );
  }
}
