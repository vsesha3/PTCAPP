import 'package:flutter/material.dart';

class Student {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController otherInfoController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  String selectedGender = 'Male';
  DateTime? selectedDate;
  String selectedBranch = 'Bakhundole';
  String? photoBase64;
  String? selectedNationality;

  // Workshop selection states
  final Map<String, bool> workshopSelections = {
    'Basic Grooming Workshop': false,
    'Advanced Grooming Workshop': false,
    'Pet Styling Workshop': false,
    'Pet Care Workshop': false,
    'Business Management Workshop': false,
  };

  // Workshop data loading states
  List<Map<String, dynamic>> workshopOptions = [];
  String? selectedWorkshop;
  bool isLoadingWorkshops = true;

  // Nationality states
  List<String> nationalities = [];
  bool isLoadingNationalities = true;

  // Getter for selected workshops
  List<String> get selectedWorkshops => workshopSelections.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();

  // Getter for display text
  String get workshopDisplayText {
    if (selectedWorkshops.isEmpty) return 'Select workshops';
    if (selectedWorkshops.length == 1) return selectedWorkshops.first;
    return '${selectedWorkshops.length} workshops selected';
  }

  // Initialize fields from data
  void initializeFromData(Map<String, dynamic> data) {
    nameController.text = data['name'] ?? '';
    nickNameController.text = data['nickname'] ?? '';
    schoolController.text = data['school'] ?? '';
    otherInfoController.text = data['other_info'] ?? '';
    ageController.text = data['age'] ?? '';
    selectedGender = data['gender'] ?? 'Male';
    selectedBranch = data['branch'] ?? 'Bakhundole';
    photoBase64 = data['photo'];
    selectedNationality = data['nationality'];

    if (data['dob'] != null) {
      try {
        selectedDate = DateTime.parse(data['dob']);
        dateOfBirthController.text = _formatDate(selectedDate!);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Get form data
  Map<String, dynamic> getFormData() {
    return {
      'name': nameController.text,
      'dob': dateOfBirthController.text,
      'gender': selectedGender,
      'nationality': selectedNationality,
      'workshops': selectedWorkshops,
      'branch': selectedBranch,
      'nickname': nickNameController.text,
      'school': schoolController.text,
      'other_info': otherInfoController.text,
      'age': ageController.text,
      'photo': photoBase64,
    };
  }

  // Validate form
  bool validateForm(GlobalKey<FormState> formKey) {
    if (formKey.currentState == null) return false;

    bool isValid = true;

    // Check if full name is provided
    if (nameController.text.isEmpty) {
      isValid = false;
    }

    // Check if date of birth is provided
    if (dateOfBirthController.text.isEmpty) {
      isValid = false;
    }

    // Check if gender is selected
    if (selectedGender.isEmpty) {
      isValid = false;
    }

    // Check if branch is selected
    if (selectedBranch.isEmpty) {
      isValid = false;
    }

    // Check if nationality is selected
    if (selectedNationality == null) {
      isValid = false;
    }

    // Check if at least one workshop is selected
    if (selectedWorkshops.isEmpty) {
      isValid = false;
    }

    // Validate the form state
    isValid = isValid && formKey.currentState!.validate();

    return isValid;
  }

  // Calculate age from date of birth
  void calculateAge(DateTime dateOfBirth) {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    ageController.text = age.toString();
  }

  // Dispose controllers
  void dispose() {
    nameController.dispose();
    nickNameController.dispose();
    schoolController.dispose();
    otherInfoController.dispose();
    ageController.dispose();
    dateOfBirthController.dispose();
    genderController.dispose();
  }
}
