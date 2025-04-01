import 'package:flutter/material.dart';

class SVSGridView extends StatelessWidget {
  final List<Map<String, dynamic>> rowData;
  final List<String> columnstoShow;
  final int limitRows;

  const SVSGridView({super.key, 
    required this.rowData,
    required this.columnstoShow,
    required this.limitRows,
  });

  String toProperCase(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  String truncateTextByScreenSize(String text, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust truncation logic based on screen size
    if (screenWidth > 1024) {
      return text;
    } else if (screenWidth > 768) {
      return text.length > 40 ? '${text.substring(0, 40)}...' : text;
    } else {
      return text.length > 30 ? '${text.substring(0, 30)}...' : text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Table Header
            Container(
              color: Colors.white,
              child: Row(
                children: columnstoShow.map((col) {
                  return Flexible(
                    fit: FlexFit.tight, // Ensures equal space distribution
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        toProperCase(col),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Table Rows
            Container(
              color: Colors.white,
              child: Column(
                children: rowData.take(limitRows).map((row) {
                  return Row(
                    children: columnstoShow.map((col) {
                      return Flexible(
                        fit: FlexFit.tight, // Ensures equal space distribution
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            '',
                            style: TextStyle(
                              overflow: TextOverflow
                                  .ellipsis, // Truncates text when it overflows
                            ),
                            softWrap: true, // Allows text to wrap
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
