import 'package:flutter/material.dart';

class ViewTable extends StatefulWidget {
  final List<Map<String, dynamic>> rowData;
  final List<String> columnstoShow;
  final int limitRows;

  const ViewTable({super.key, 
    required this.rowData,
    required this.columnstoShow,
    required this.limitRows,
  });

  @override
  _ViewTableState createState() => _ViewTableState();
}

class _ViewTableState extends State<ViewTable> {
  int? hoveredRowIndex; // Tracks which row is hovered

  bool isNumeric(String value) {
    if (value.isEmpty) return false;
    final number = num.tryParse(value);
    return number != null;
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      columnWidths: {
        for (int i = 0; i < widget.columnstoShow.length; i++)
          i: FlexColumnWidth(),
      },
      children: [
        // Header Row
        TableRow(
          children: widget.columnstoShow.map((col) {
            return Container(
              padding: EdgeInsets.all(8),
              color: Colors.grey[300],
              child: Text(
                col,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
        // Data Rows with Hover Effect
        ...widget.rowData.asMap().entries.take(widget.limitRows).map((entry) {
          int rowIndex = entry.key;
          Map<String, dynamic> row = entry.value;

          return TableRow(
            children: widget.columnstoShow.map((col) {
              String cellValue = row[col]?.toString() ?? '';
              bool isNum = isNumeric(cellValue);

              return MouseRegion(
                onEnter: (_) => setState(() => hoveredRowIndex = rowIndex),
                onExit: (_) => setState(() => hoveredRowIndex = null),
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: hoveredRowIndex == rowIndex
                      ? Colors.blue[100]
                      : Colors.white,
                  alignment: isNum ? Alignment.center : Alignment.centerLeft,
                  child: Text(
                    cellValue,
                    textAlign: isNum ? TextAlign.center : TextAlign.left,
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
