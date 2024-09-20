import 'package:flutter/material.dart';
import 'package:flutter_assesment/services/product_service.dart';
import 'package:flutter_assesment/themes/theme.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class ItemTable extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final List<FocusNode> focusNodes;
  final VoidCallback checkAndAddEmptyRows;
  final bool isEditable;
  final Function(int index, String field, dynamic value) onItemChanged;

  const ItemTable({
    Key? key,
    required this.items,
    required this.focusNodes,
    required this.checkAndAddEmptyRows,
    required this.isEditable,
    required this.onItemChanged,
  }) : super(key: key);

  @override
  _ItemTableState createState() => _ItemTableState();
}

class _ItemTableState extends State<ItemTable> {
  final ImagePicker _picker = ImagePicker();
  final ProductService _productService = ProductService();
  late Future<List<String>> _productNames;

  @override
  void initState() {
    super.initState();
    // Fetching product names when the widget is initialized
    _productNames = _productService.fetchProductNames();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(50),
        1: FlexColumnWidth(),
      },
      border: const TableBorder(
        horizontalInside: BorderSide(width: 1.0, color: Colors.teal),
        verticalInside: BorderSide(width: 1.0, color: Colors.teal),
      ),
      children: widget.items.asMap().entries.map((entry) {
        int index = entry.key;
        var item = entry.value;

        // Rendering each row with quantity and name cells
        return TableRow(
          children: [
            _buildQuantityCell(
                index * 2, item['quantity']?.toString() ?? '', index),
            _buildNameCell(index * 2 + 1, item, index),
          ],
        );
      }).toList(),
    );
  }

  // Function to find the first empty row (quantity or name is missing)
  int _findFirstEmptyRow() {
    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      if ((item['quantity'] == null || item['quantity'] == 0) ||
          (item['name'] == null || item['name'].isEmpty)) {
        return i; // Return index of the first empty row
      }
    }
    return -1; // Return -1 if no empty row is found
  }

  // Validate if both quantity and name fields are filled and valid for an item
  bool _validateItem(int index) {
    final quantity = widget.items[index]['quantity'];
    final name = widget.items[index]['name'];

    return (quantity != null && quantity > 0) &&
        (name != null && name.isNotEmpty);
  }

  // Build quantity input field with validation and focus handling
  Widget _buildQuantityCell(int focusIndex, String initialValue, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: GestureDetector(
        onTap: () {
          final emptyRowIndex = _findFirstEmptyRow();
          if (emptyRowIndex != -1 && emptyRowIndex < index) {
            // Redirect focus to the first empty row's quantity cell
            FocusScope.of(context)
                .requestFocus(widget.focusNodes[emptyRowIndex * 2]);
          }
        },
        child: TextFormField(
          initialValue: initialValue,
          focusNode: widget.focusNodes[focusIndex],
          enabled: widget.isEditable && index <= _findFirstEmptyRow(),
          textAlign: TextAlign.right,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          ),
          style: AppTheme.textStyle4.copyWith(color: Colors.black),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a quantity';
            }
            final quantity = int.tryParse(value);
            if (quantity == null || quantity < 0) {
              return 'Please enter a valid quantity';
            }
            return null;
          },
          onChanged: (value) {
            // Update quantity in the list and trigger change events
            widget.items[focusIndex ~/ 2]['quantity'] = int.tryParse(value);
            widget.checkAndAddEmptyRows();
            widget.onItemChanged(index, 'quantity', int.tryParse(value));

            setState(() {
              _validateItem(focusIndex ~/ 2); // Validate item after change
            });
          },
        ),
      ),
    );
  }

  // Build name input field with suggestions, note, and image options
  Widget _buildNameCell(int focusIndex, Map<String, dynamic> item, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: GestureDetector(
        onLongPress: () => _openModal(context, item),
        onDoubleTap: () => _openModal(context, item),
        onTap: () {
          final emptyRowIndex = _findFirstEmptyRow();
          if (emptyRowIndex != -1 && emptyRowIndex < index) {
            // Redirect focus to the first empty row's name cell
            FocusScope.of(context)
                .requestFocus(widget.focusNodes[emptyRowIndex * 2 + 1]);
          }
        },
        child: Row(
          children: [
            Expanded(
              child: TypeAheadField(
                suggestionsCallback: (value) {
                  return getFilteredProductList(
                      value); // Get filtered product suggestions
                },
                focusNode: widget.focusNodes[focusIndex],
                itemBuilder: (context, String suggestion) {
                  return SizedBox(
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(suggestion),
                    ),
                  );
                },
                onSelected: (String suggestion) {
                  setState(() {
                    widget.items[focusIndex ~/ 2]['name'] = suggestion;
                    widget.checkAndAddEmptyRows();

                    _validateItem(
                        focusIndex ~/ 2); // Validate item after selection
                  });
                },
                builder: (context, controller, focusNode) {
                  controller.text = item['name'] ?? ''; // Display current name
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    enabled: widget.isEditable && index <= _findFirstEmptyRow(),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                    ),
                    style: AppTheme.textStyle4.copyWith(color: Colors.black),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      widget.items[focusIndex ~/ 2]['name'] = value;
                      widget.checkAndAddEmptyRows();

                      _validateItem(
                          focusIndex ~/ 2); // Validate after changing name
                      widget.onItemChanged(index, 'name', value);
                    },
                  );
                },
              ),
            ),
            // Display note icon if a note exists
            if (item['note'] != null && item['note'].isNotEmpty)
              GestureDetector(
                onTap: () => _showInfoDialog(item['note']),
                child: const Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                  size: 26,
                ),
              ),
            // Display image icon if an image exists
            if (item['image'] != null)
              Padding(
                padding: const EdgeInsets.only(left: 6, right: 12),
                child: GestureDetector(
                  onTap: () => _showImageDialog(item['image']),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppTheme.primaryColor,
                    size: 26,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Modal for adding/editing product notes and selecting an image
  void _openModal(BuildContext context, Map<String, dynamic> item) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController noteController =
            TextEditingController(text: item['note'] ?? '');
        String? selectedImage = item['image'];

        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: noteController,
                decoration: InputDecoration(
                  labelText: 'Add Notes',
                  labelStyle: AppTheme.textStyle1
                      .copyWith(color: AppTheme.secondaryColor),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      selectedImage = pickedFile.path;
                    });
                  }
                },
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Select Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'note': noteController.text,
                  'image': selectedImage,
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        item['note'] = result['note'];
        item['image'] = result['image'];
      });
    }
  }

  // Dialog to show product notes
  void _showInfoDialog(String note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Product Note',
            style: AppTheme.textStyle1.copyWith(color: AppTheme.secondaryColor),
          ),
          content: Text(note, style: AppTheme.textStyle4),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Dialog to show the product image
  void _showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Product Image',
            style: AppTheme.textStyle1.copyWith(color: AppTheme.secondaryColor),
          ),
          content: Image.file(File(imagePath)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Filtering product list based on the input query
  Future<List<String>> getFilteredProductList(String query) async {
    List<String> productNames = await _productNames;
    return productNames
        .where((s) => s.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
