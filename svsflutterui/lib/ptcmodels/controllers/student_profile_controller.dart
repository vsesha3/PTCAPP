import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../student_model.dart';
import '../../services/api_service.dart';

class StudentProfileController extends ChangeNotifier {
  StudentProfileModel? _studentProfile;
  bool _isLoading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  // Getters
  StudentProfileModel? get studentProfile => _studentProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Initialize with empty profile
  StudentProfileController() {
    _studentProfile = StudentProfileModel.empty();
  }

  // Load student profile from API
  Future<void> loadStudentProfile(int studentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getStudentDetails(studentId);

      if (response['status'] == 200) {
        final data = response['data'];

        if (data != null) {
          // Create StudentModel
          final student = StudentModel(
            full_name: data['student']['full_name'] ?? '',
            nickname: data['student']['nickname'] ?? '',
            school: data['student']['school'] ?? '',
            other_info: data['student']['other_info'] ?? '',
            date_of_birth: data['student']['date_of_birth'] ?? '',
            age: data['student']['age'] ?? 0,
            gender: data['student']['gender'] ?? '',
            branch: data['student']['branch'] ?? '',
            nationality: data['student']['nationality'] ?? '',
            photograph: data['student']['photograph'] ?? '',
          );

          // Create ParentsModel
          final parent = ParentsModel(
            father_first_name: data['parent']['father_first_name'] ?? '',
            father_photo: data['parent']['father_photo'] ?? '',
            father_contact: data['parent']['father_contact'] ?? '',
            father_email: data['parent']['father_email'] ?? '',
            father_social_media: data['parent']['father_social_media'] ?? '',
            father_profession: data['parent']['father_profession'] ?? '',
            father_date_of_birth: data['parent']['father_date_of_birth'] ?? '',
            father_age: data['parent']['father_age'] ?? 0,
            mother_photo: data['parent']['mother_photo'] ?? '',
            mother_first_name: data['parent']['mother_first_name'] ?? '',
            mother_contact: data['parent']['mother_contact'] ?? '',
            mother_email: data['parent']['mother_email'] ?? '',
            mother_social_media: data['parent']['mother_social_media'] ?? '',
            mother_profession: data['parent']['mother_profession'] ?? '',
            mother_date_of_birth: data['parent']['mother_date_of_birth'] ?? '',
            mother_age: data['parent']['mother_age'] ?? 0,
          );

          // Create AddressModel
          final address = AddressModel(
            address: data['address']['address'] ?? '',
            work_address: data['address']['work_address'] ?? '',
            emergency_contact: data['address']['emergency_contact'] ?? '',
          );

          // Create StudentProfileModel
          _studentProfile = StudentProfileModel(
            id: data['id'] ?? 0,
            student: student,
            parent: parent,
            address: address,
            source: data['source'] ?? '',
            other_source: data['other_source'] ?? '',
            created_at: data['created_at'] ?? '',
            updated_at: data['updated_at'] ?? '',
          );
        } else {
          _error = 'No student data found';
          _studentProfile = StudentProfileModel.empty();
        }
      } else {
        _error = 'Failed to load student profile: ${response['status']}';
        _studentProfile = StudentProfileModel.empty();
      }
    } catch (e) {
      _error = 'Failed to load student profile: $e';
      _studentProfile = StudentProfileModel.empty();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update student profile
  void updateStudentProfile(StudentProfileModel profile) {
    _studentProfile = profile;
    _error = null;
    notifyListeners();
  }

  // Clear student profile
  void clearStudentProfile() {
    _studentProfile = StudentProfileModel.empty();
    _error = null;
    notifyListeners();
  }

  // Update student details
  void updateStudentDetails(StudentModel student) {
    if (_studentProfile != null) {
      _studentProfile = StudentProfileModel(
        id: _studentProfile!.id,
        student: student,
        parent: _studentProfile!.parent,
        address: _studentProfile!.address,
        source: _studentProfile!.source,
        other_source: _studentProfile!.other_source,
        created_at: _studentProfile!.created_at,
        updated_at: _studentProfile!.updated_at,
      );
      notifyListeners();
    }
  }

  // Update parent details
  void updateParentDetails(ParentsModel parent) {
    if (_studentProfile != null) {
      _studentProfile = StudentProfileModel(
        id: _studentProfile!.id,
        student: _studentProfile!.student,
        parent: parent,
        address: _studentProfile!.address,
        source: _studentProfile!.source,
        other_source: _studentProfile!.other_source,
        created_at: _studentProfile!.created_at,
        updated_at: _studentProfile!.updated_at,
      );
      notifyListeners();
    }
  }

  // Update address details
  void updateAddressDetails(AddressModel address) {
    if (_studentProfile != null) {
      _studentProfile = StudentProfileModel(
        id: _studentProfile!.id,
        student: _studentProfile!.student,
        parent: _studentProfile!.parent,
        address: address,
        source: _studentProfile!.source,
        other_source: _studentProfile!.other_source,
        created_at: _studentProfile!.created_at,
        updated_at: _studentProfile!.updated_at,
      );
      notifyListeners();
    }
  }

  // Update source information
  void updateSourceInfo(String source, String otherSource) {
    if (_studentProfile != null) {
      _studentProfile = StudentProfileModel(
        id: _studentProfile!.id,
        student: _studentProfile!.student,
        parent: _studentProfile!.parent,
        address: _studentProfile!.address,
        source: source,
        other_source: otherSource,
        created_at: _studentProfile!.created_at,
        updated_at: _studentProfile!.updated_at,
      );
      notifyListeners();
    }
  }
}
