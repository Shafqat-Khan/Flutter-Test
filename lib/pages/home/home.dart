import 'package:flutter/material.dart';
import 'package:flutter_assesment/common_widgets/app_drawer.dart';
import 'package:flutter_assesment/common_widgets/custom_app_bar.dart';
import 'package:flutter_assesment/pages/order_preview/order_details.dart';
import 'package:flutter_assesment/themes/theme.dart';
import 'item_table.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _items =
      []; // Holds the list of items (products) with quantity and name
  final List<FocusNode> _focusNodes = []; // Manages focus for editable fields
  final int _emptyRowsToShow =
      20; // Minimum number of empty rows to show in the table
  bool _isEditable = false; // Tracks whether editing is enabled
  bool _isSubmitted = false; // Tracks whether the form has been submitted

  @override
  void initState() {
    super.initState();
    _initializeFocusNodes(); // Initialize focus nodes
    _ensureEmptyRows(); // Ensure the table has empty rows
  }

  // Initializes focus nodes for table inputs
  void _initializeFocusNodes() {
    _focusNodes.clear();
    for (int i = 0; i < _items.length * 2; i++) {
      _focusNodes.add(FocusNode());
    }
  }

  // Ensures the table has at least some rows
  void _ensureEmptyRows() {
    int emptyRowsNeeded = _emptyRowsToShow - _items.length;
    if (emptyRowsNeeded > 0) {
      setState(() {
        _items.addAll(List.generate(
            emptyRowsNeeded, (index) => {'quantity': null, 'name': ''}));
        _initializeFocusNodes(); // Reinitialize focus nodes based on new rows
      });
    }
  }

  // Toggles the edit mode of the table
  void _toggleEdit() {
    setState(() {
      _isEditable = !_isEditable;
    });
  }

  // Validates and submits the data
  void _submitData() {
    // Check if all non-empty rows have both quantity and name filled
    bool isValid = _items
        .where((item) => item['quantity'] != null || item['name'].isNotEmpty)
        .every((item) {
      return item['quantity'] != null &&
          item['quantity'] != 0 &&
          item['name'].isNotEmpty;
    });

    if (isValid) {
      setState(() {
        _isEditable = false; // Disable editing after submission
        _isSubmitted = true; // Mark form as submitted
      });
    } else {
      _showValidationError(); // Show validation error if the data is invalid
    }
  }

  // Displays validation error dialog
  void _showValidationError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Validation Error', style: AppTheme.textStyle1),
          content: const Text(
              'Please enter both quantity and product name for all items.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Clears the form and resets items
  void _clearData() {
    setState(() {
      _items.clear(); // Clear all items
      _focusNodes.clear(); // Clear focus nodes
      _ensureEmptyRows(); // Add empty rows
    });
  }

  // Navigate to Order Details page
  void _navigateToOrderDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailsPage()),
    );
  }

  // Cancels the submission and allows editing again
  void _cancelSubmission() {
    setState(() {
      _isSubmitted = false;
    });
  }

  // Updates an item in the table based on index, field, and value
  void _updateItem(int index, String field, dynamic value) {
    setState(() {
      _items[index][field] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      appBar: const CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display buttons after form submission
          if (_isSubmitted)
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed:
                        _cancelSubmission, // Allow canceling the submission
                    icon: Icon(Icons.close),
                    style: IconButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor),
                  ),
                  IconButton(
                    onPressed:
                        _navigateToOrderDetails, // Go to order details page
                    style: IconButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor),
                    icon: const Icon(Icons.arrow_forward),
                    tooltip: 'Go to Order Details',
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  'Order # ',
                  style: AppTheme.textStyle1
                      .copyWith(color: AppTheme.secondaryColor),
                ),
                Text(
                  "112096", // Sample order number
                  style: AppTheme.textStyle1
                      .copyWith(color: AppTheme.primaryColor),
                ),
                if (!_isSubmitted)
                  TextButton(
                    onPressed: _toggleEdit, // Toggle edit mode
                    child: Text(
                      _isEditable ? '(disable edit)' : '(allow edit)',
                      style: AppTheme.textStyle1
                          .copyWith(color: AppTheme.primaryColor),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ItemTable(
                key: ValueKey<List<Map<String, dynamic>>>(_items),
                items: _items, // Pass items to the table
                focusNodes: _focusNodes, // Pass focus nodes for editable fields
                checkAndAddEmptyRows: _ensureEmptyRows, // Ensure empty rows
                isEditable: _isEditable, // Pass editable state
                onItemChanged: _updateItem, // Handle item changes
              ),
            ),
          ),
          // Display action buttons (Submit, Clear) when editable and not submitted
          if (_isEditable && !_isSubmitted)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _items.any((item) =>
                            (item['quantity'] != null &&
                                item['quantity'] != 0) ||
                            item['name'].isNotEmpty)
                        ? _submitData
                        : null, // Enable button only if there are valid items
                    child: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed:
                        null, // Button disabled until validation logic allows clearing
                    child: const Text('Clear'),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
