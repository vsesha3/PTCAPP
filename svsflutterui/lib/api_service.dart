import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String loginUrl =
      'http://localhost:8080/guptaapi/api/login'; // Replace with your API login URL
  final String baseUrl = 'http://localhost:8080/guptaapi/api/fetchSummaryData';

  Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
          {'userName': username, 'password': password, 'newPassword': ''}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token']; // Adjust based on your API response
    } else {
      throw Exception('Failed to authenticate');
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
