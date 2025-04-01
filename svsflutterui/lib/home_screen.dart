import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart'; // Import your AuthProvider
import 'api_service.dart'; // Import your ApiService

import 'table_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _rowData = [];
  int _totalPages = 0;
  Map<String, dynamic> _summaryDetails = {};
  Map<String, dynamic> _pageData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final apiService = ApiService();

    await apiService.fetchImportDetails(
      currentPage: 1,
      setRowData: (data) {
        setState(() {
          _rowData = data;
        });
      },
      setTotalPages: (pages) {
        setState(() {
          _totalPages = pages;
        });
      },
      setSummaryDetails: (details) {
        setState(() {
          _summaryDetails = details;
        });
      },
      setPageData: (pageData) {
        setState(() {
          _pageData = pageData;
        });
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? token = Provider.of<AuthProvider>(context).token;
    List<String> columnTitles = _rowData.first.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Test'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Remove the token display text here
                Expanded(
                  child: ViewTable(
                    rowData: _rowData,
                    columnstoShow: columnTitles,
                    limitRows: 10,
                  ),
                ),
              ],
            ),
    );
  }
}
