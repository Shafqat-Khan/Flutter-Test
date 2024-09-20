import 'package:flutter/material.dart';
import 'package:flutter_assesment/themes/theme.dart';

// Custom painter to draw a menu icon with equal left sides and a longer right center line.
class CustomMenuIcon extends StatelessWidget {
  const CustomMenuIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24, // Adjust the width as needed.
      height: 24, // Adjust the height as needed.
      child: CustomPaint(
        painter: _MenuIconPainter(),
      ),
    );
  }
}

// The custom painter that defines the appearance of the menu icon.
class _MenuIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor // Color of the lines.
      ..strokeWidth = 2; // Thickness of the lines.

    final double lineLength =
        size.width * 0.6; // Length of the top and bottom lines.
    final double centerLineLength =
        size.width * 0.8; // Length of the center line.

    // Positioning lines with equal spacing vertically.
    final double yOffsetTop = size.height * 0.25; // First line position.
    final double yOffsetCenter = size.height * 0.5; // Center line position.
    final double yOffsetBottom = size.height * 0.75; // Third line position.

    // Draw the first line (equal on both sides).
    canvas.drawLine(
      Offset(0, yOffsetTop), // Starting point (left).
      Offset(lineLength, yOffsetTop), // End point (shorter, left).
      paint,
    );

    // Draw the center line (longer on the right).
    canvas.drawLine(
      Offset(0, yOffsetCenter), // Starting point (left).
      Offset(
          centerLineLength, yOffsetCenter), // End point (longer on the right).
      paint,
    );

    // Draw the third line (equal on both sides).
    canvas.drawLine(
      Offset(0, yOffsetBottom), // Starting point (left).
      Offset(lineLength, yOffsetBottom), // End point (shorter, left).
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// CustomAppBar with the custom menu icon.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const CustomMenuIcon(), // Using the custom menu icon.
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      title: const Image(
        image: AssetImage('assets/icons/logo.png'),
        height: 110,
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
    );
  }
}
