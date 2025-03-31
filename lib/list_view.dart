import 'package:flutter/material.dart';

class ViewList extends StatelessWidget {
  final List<Map<String, dynamic>> rowData;
  final List<String> columnstoShow;
  final int limitRows;

  const ViewList({super.key, 
    required this.rowData,
    required this.columnstoShow,
    required this.limitRows,
  });

  bool isNumeric(String value) {
    if (value.isEmpty) return false;
    final number = num.tryParse(value);
    return number != null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Table Header Row with full left, right margins and a bottom border
        Padding(
          padding: const EdgeInsets.only(
              top: 16.0,
              left: 16.0,
              right: 16.0), // Added top margin for the header
          child: Row(
            children: columnstoShow.map((column) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0), // Vertical padding for header
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Colors.grey,
                            width: 1), // Bottom border for the header
                      ),
                    ),
                    child: Text(
                      column,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center, // Center align header text
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Table Rows with data, using margins for each column
        Expanded(
          child: ListView.builder(
            itemCount: rowData.length, // Number of items in the list
            itemBuilder: (context, index) {
              var item = rowData[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 0.0), // Vertical padding for rows
                child: Row(
                  children: columnstoShow.asMap().entries.map((entry) {
                    int columnIndex = entry.key;
                    String column = entry.value;
                    var value = item[column] ?? ''; // Fallback for null values
                    bool isValueNumeric = isNumeric(
                        value.toString()); // Check if value is numeric

                    // Determine if it's the first or last column to apply appropriate margin
                    EdgeInsetsGeometry padding = EdgeInsets.symmetric(
                        horizontal: 16.0); // Default padding
                    if (columnIndex == 0) {
                      print('$columnIndex column index');
                      // First column - apply left margin and left border only
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 16.0), // Add left margin only
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.grey,
                                width:
                                    1, // Add left border for the first column
                              ),
                            ),
                          ),
                          child: Text(
                            value.toString(),
                            textAlign: isValueNumeric
                                ? TextAlign.center
                                : TextAlign.left, // Center if numeric
                            overflow: TextOverflow.ellipsis, // Handle long text
                          ),
                        ),
                      );
                    } else if (columnIndex == columnstoShow.length - 1) {
                      // Last column - apply right margin only
                      return Padding(
                        padding: EdgeInsets.only(
                            right: 16.0), // Add right margin only
                        child: Container(
                          child: Text(
                            value.toString(),
                            textAlign: isValueNumeric
                                ? TextAlign.center
                                : TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: Padding(
                        padding: padding, // Conditional left or right margin
                        child: Text(
                          value.toString(),
                          textAlign: isValueNumeric
                              ? TextAlign.center
                              : TextAlign.left, // Center if numeric
                          overflow: TextOverflow.ellipsis, // Handle long text
                        ),
                      ),
                    );
                  }).toList(), // Create a list of widgets
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
