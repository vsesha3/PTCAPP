import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // Static URL constants
  static String get baseUrl {
    if (kDebugMode) {
      return 'http://localhost:5000/api'; // Local development
    } else {
      return '/api'; // Production with Nginx proxy
    }
  }

  static String get loginUrl => '$baseUrl/login';
  static String get studentUrl => '$baseUrl/saveStudentData';
  static String get parentUrl => '$baseUrl/parent';
  static String get questionsUrl => '$baseUrl/questions';

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  // Get the stored token
  Future<String?> _getToken() async {
    await _ensureInitialized();
    return _prefs?.getString('auth_token');
  }

  // Login method
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'];
        if (token != null) {
          // Store the token
          await _ensureInitialized();
          await _prefs?.setString('auth_token', token);
          return {
            'success': true,
            'token': token,
            'message': data['message'] ?? 'Login successful'
          };
        }
      }

      // Handle error response
      return {
        'success': false,
        'token': null,
        'message':
            data['message'] ?? 'Login failed. Please check your credentials.'
      };
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'token': null,
        'message': 'Connection error. Please check your internet connection.'
      };
    }
  }

  // Save student data
  Future<Map<String, dynamic>> saveStudentData(
      Map<String, dynamic> data) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated. Please login again.'
        };
      }

      final response = await http.post(
        Uri.parse(studentUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'],
          'student_id': responseData['student_id']
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to save student data'
        };
      }
    } catch (e) {
      print('Save student data error: $e');
      return {
        'success': false,
        'message': 'Connection error. Please check your internet connection.'
      };
    }
  }

  // Save parent profile
  Future<bool> saveParentProfile(Map<String, dynamic> parentData) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.post(
        Uri.parse(parentUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(parentData),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Save parent profile error: $e');
      return false;
    }
  }

  // Save questions
  Future<bool> saveQuestions(Map<String, dynamic> questionsData) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.post(
        Uri.parse(questionsUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(questionsData),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Save questions error: $e');
      return false;
    }
  }

  // Fetch student profile
  Future<Map<String, dynamic>?> fetchStudentProfile() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse(studentUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Fetch student profile error: $e');
      return null;
    }
  }

  // Fetch parent profile
  Future<Map<String, dynamic>?> fetchParentProfile() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse(parentUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Fetch parent profile error: $e');
      return null;
    }
  }

  // Fetch questions
  Future<Map<String, dynamic>?> fetchQuestions() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse(questionsUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Fetch questions error: $e');
      return null;
    }
  }

  Future<void> fetchImportDetails({
    required int currentPage,
    required Function(List<Map<String, dynamic>>) setRowData,
    required Function(int) setTotalPages,
    required Function(Map<String, dynamic>) setSummaryDetails,
    required Function(Map<String, dynamic>) setPageData,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return;

      // Define the URL and request body
      String url = baseUrl;
      Map<String, dynamic> jsonBody = {
        'pageNo': [currentPage],
        'itemCount': [10],
        'sortMethod': ['DEFAULT'],
      };

      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonBody),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Process the response
        final List<dynamic> dataList = responseData['dataList']['content'];
        final int totalElements = responseData['dataList']['totalElements'];
        final int totalPages =
            (totalElements / jsonBody['itemCount'][0]).ceil();

        // Cast the dataList to List<Map<String, dynamic>>
        final List<Map<String, dynamic>> castedDataList =
            dataList.cast<Map<String, dynamic>>();

        // Update the state using the provided callbacks
        setRowData(castedDataList);
        setTotalPages(totalPages);
        setSummaryDetails(responseData['summaryDetails']);

        // Prepare page data
        final Map<String, dynamic> pageData = {
          'currentPage': responseData['dataList']['pageable']['pageNumber'],
          'totalPages': totalPages,
          'handlePageChange': (int page) {
            // Handle page change (you can implement this function)
            print('Page changed to $page');
          },
          'hideView': false, // You can customize this
        };

        setPageData(pageData);
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<Map<String, dynamic>> getStudentsList({
    required int page,
    required int itemsPerPage,
  }) async {
    try {
      final token = await _getToken();
      print('StudentListScreen Load Methods api service $token');
      if (token == null) {
        return {
          'status': 401,
          'message': 'Not authenticated',
          'data': [],
          'total_pages': 1
        };
      }

      final response = await http.get(
        Uri.parse(
            '$baseUrl/getStudentsList?page=$page&itemsPerPage=$itemsPerPage'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> data = jsonDecode(response.body);

          // Check if we have any data at all
          if (data.isEmpty) {
            return {
              'status': 200,
              'message': 'No students found',
              'data': [],
              'total_pages': 1
            };
          }

          // If data is a list, wrap it in the expected structure
          if (data is List) {
            return {
              'status': 200,
              'message': 'Students retrieved successfully',
              'data': data,
              'total_pages': 1
            };
          }

          // Check for expected structure
          if (data.containsKey('data')) {
            final responseData = data['data'];

            // Handle both array and object responses
            if (responseData is List) {
              return {
                'status': 200,
                'message': data['message'] ?? 'Students retrieved successfully',
                'data': responseData,
                'total_pages': data['total_pages'] ?? 1
              };
            } else if (responseData is Map) {
              // If data is a map, convert it to a list
              return {
                'status': 200,
                'message': data['message'] ?? 'Students retrieved successfully',
                'data': [responseData],
                'total_pages': data['total_pages'] ?? 1
              };
            }
          }

          // If we get here, the response format is unexpected
          return {
            'status': 400,
            'message': 'Invalid response format: ${data.runtimeType}',
            'data': [],
            'total_pages': 1
          };
        } catch (e) {
          return {
            'status': 400,
            'message': 'Error parsing response: $e',
            'data': [],
            'total_pages': 1
          };
        }
      } else {
        try {
          final errorData = jsonDecode(response.body);
          return {
            'status': response.statusCode,
            'message': errorData['message'] ?? 'Failed to fetch students list',
            'data': [],
            'total_pages': 1
          };
        } catch (e) {
          return {
            'status': response.statusCode,
            'message':
                'Failed to fetch students list (Status: ${response.statusCode})',
            'data': [],
            'total_pages': 1
          };
        }
      }
    } catch (e) {
      return {
        'status': 500,
        'message': 'An error occurred: $e',
        'data': [],
        'total_pages': 1
      };
    }
  }

  Future<Map<String, dynamic>> deleteStudent(int studentId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated',
        };
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/deleteStudent/$studentId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getStudentDetails(int studentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getStudentDetails?id=$studentId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Student Details Response Status: ${response.statusCode}');
      print('Student Details Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return {
            'status': 200,
            'data': data['data'],
            'message':
                data['message'] ?? 'Student details fetched successfully',
          };
        } else {
          return {
            'status': response.statusCode,
            'message': data['message'] ?? 'Failed to fetch student details',
          };
        }
      } else {
        return {
          'status': response.statusCode,
          'message': 'Failed to fetch student details',
        };
      }
    } catch (e) {
      print('Error fetching student details: $e');
      return {
        'status': 500,
        'message': 'Error fetching student details: $e',
      };
    }
  }
}
