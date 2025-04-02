import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Static URL constants
  static const String baseUrl =
      'http://localhost:5000/api'; // Replace with your Python backend URL
  static const String loginUrl = '$baseUrl/login';
  static const String studentUrl = '$baseUrl/saveStudentData';
  static const String parentUrl = '$baseUrl/parent';
  static const String questionsUrl = '$baseUrl/questions';

  // Get the stored token
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
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
    // Retrieve the token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    // Define the URL and request body
    String url = baseUrl;
    Map<String, dynamic> jsonBody = {
      'pageNo': [currentPage],
      'itemCount': [10],
      'sortMethod': ['DEFAULT'],
    };

    try {
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
}
