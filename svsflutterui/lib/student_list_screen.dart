import 'package:flutter/material.dart';
import 'package:svsflutterui/api_service.dart';
import 'package:svsflutterui/student_profile_screen.dart';
import 'package:svsflutterui/tabbed_layout.dart';
import 'dart:convert';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final _apiService = ApiService();
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = true;
  int _currentPage = 1;
  int _totalPages = 1;
  final int _itemsPerPage = 10;
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic>? _selectedStudent;
  final Set<int> _selectedStudentIds = {}; // Track multiple selected students
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiService.getStudentsList(
        page: _currentPage,
        itemsPerPage: _itemsPerPage,
      );

      if (response['status'] == 200) {
        final data = response['data'];

        if (data is List && data.isNotEmpty) {
          final firstItem = data[0];
          if (firstItem is Map && firstItem.containsKey('data')) {
            final studentsData = firstItem['data'];

            if (studentsData is List && studentsData.isNotEmpty) {
              setState(() {
                _students = studentsData.cast<Map<String, dynamic>>();
                _totalPages = firstItem['total_pages'] ?? 1;
              });
            } else {
              setState(() {
                _errorMessage = 'No students found';
                _students = [];
              });
            }
          } else {
            setState(() {
              _errorMessage = 'Invalid data format';
              _students = [];
            });
          }
        } else {
          setState(() {
            _errorMessage = 'No data received';
            _students = [];
          });
        }
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Failed to load students';
          _students = [];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _students = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    print('StudentListScreen Load Methods');
  }

  Future<void> _deleteStudent(int studentId) async {
    try {
      final response = await _apiService.deleteStudent(studentId);
      if (response['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(response['message'] ?? 'Student deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _loadStudents(); // Refresh the list
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Failed to delete student'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting student: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(int studentId, String studentName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Student'),
        content: Text('Are you sure you want to delete $studentName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteStudent(studentId);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showStudentForm({Map<String, dynamic>? studentData}) {
    // Debug print
    print('Showing student form with ID: ${studentData?['id']}');
    print(MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width >= 1024) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TabbedLayout(
            studentId: studentData?['id'],
            onSave: () {
              _loadStudents();
            },
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            child: StudentProfileScreen(
              studentId: studentData?['id'],
            ),
          ),
        ),
      ).then((_) {
        print('Student form closed, refreshing list...');
        _loadStudents();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students List'),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Student'),
            onPressed: () => _showStudentForm(),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _currentPage = 1; // Reset to first page
                _selectedStudentIds.clear(); // Clear selections
                _selectedStudent = null;
              });
              _loadStudents();
            },
            tooltip: 'Refresh List',
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  print(_selectedStudent);
                  if (_selectedStudent != null) {
                    _showStudentForm(studentData: _selectedStudent);
                  }
                  break;
                case 'delete':
                  if (_selectedStudent != null) {
                    _showDeleteConfirmation(
                      _selectedStudent!['id'],
                      _selectedStudent!['full_name'],
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                enabled: _selectedStudent != null,
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit Student'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                enabled: _selectedStudent != null,
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Student', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Table or List View
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 600) {
                            return _buildMobileView();
                          } else {
                            return _buildDesktopView();
                          }
                        },
                      ),
                    ),
                  ),
                  // Pagination controls
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: _buildPaginationControls(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMobileView() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _students.length,
      itemBuilder: (context, index) {
        final student = _students[index];
        final isSelected = _selectedStudentIds.contains(student['id']);
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedStudentIds.add(student['id']);
                  } else {
                    _selectedStudentIds.remove(student['id']);
                  }
                  if (_selectedStudentIds.length == 1) {
                    _selectedStudent = student;
                  } else {
                    _selectedStudent = null;
                  }
                });
              },
            ),
            title: Text(
              '${student['full_name'] ?? ''} (${student['age'] ?? ''} years)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Mother: ${student['mother_first_name'] ?? ''}\n'
              'Father: ${student['father_first_name'] ?? ''}',
            ),
            trailing: Icon(
              Icons.image,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopView() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
        columns: [
          DataColumn(
            label: Icon(
              Icons.image,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          DataColumn(
            label: Text('Full Name',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('Age', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('Mother\'s Name',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('Father\'s Name',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label:
                Text('Contact', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label:
                Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        rows: [
          ..._students.map((student) {
            final isSelected = _selectedStudentIds.contains(student['id']);
            return DataRow(
              selected: isSelected,
              onSelectChanged: (selected) {
                setState(() {
                  if (selected == true) {
                    _selectedStudentIds.add(student['id']);
                    _selectedStudent = student;
                  } else {
                    _selectedStudentIds.remove(student['id']);
                    if (_selectedStudentIds.length == 1) {
                      _selectedStudent = _students.firstWhere(
                          (s) => s['id'] == _selectedStudentIds.first);
                    } else {
                      _selectedStudent = null;
                    }
                  }
                });
              },
              cells: [
                DataCell(
                  Icon(
                    Icons.image,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                DataCell(Text(student['full_name'] ?? '')),
                DataCell(Text(student['age']?.toString() ?? '')),
                DataCell(Text(student['mother_first_name'] ?? '')),
                DataCell(Text(student['father_first_name'] ?? '')),
                DataCell(Text(student['mother_contact'] ??
                    student['father_contact'] ??
                    '')),
                DataCell(
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          _showStudentForm(studentData: student);
                          break;
                        case 'delete':
                          _showDeleteConfirmation(
                            student['id'],
                            student['full_name'] ?? 'Unknown Student',
                          );
                          break;
                      }
                    },
                  ),
                ),
              ],
            );
          }),
          if (_selectedStudentIds.isNotEmpty)
            DataRow(
              color: WidgetStateProperty.all(Colors.grey[50]),
              cells: [
                DataCell(
                  Text(
                    '${_selectedStudentIds.length} selected',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                DataCell(Text('')),
                DataCell(Text('')),
                DataCell(Text('')),
                DataCell(Text('')),
                DataCell(Text('')),
                DataCell(Text('')),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                    _loadStudents();
                  }
                : null,
          ),
          Text('Page $_currentPage of $_totalPages'),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: _currentPage < _totalPages
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                    _loadStudents();
                  }
                : null,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
