import 'package:flutter/material.dart';

import '../../themes/theme.dart';

class OrderDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final String? subLabel1;
  final String? subLabel2;

  const OrderDetailRow({
    Key? key,
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    this.subLabel1,
    this.subLabel2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.textStyle2.copyWith(color: labelColor),
              ),
              if (subLabel1 != null)
                Text(
                  subLabel1!,
                  style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF909090)),
                ),
            ],
          ),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subLabel2 != null)
              Text(
                subLabel2!,
                style: AppTheme.textStyle3
                    .copyWith(color: const Color(0xFF909090)),
              ),
            Text(value, style: AppTheme.textStyle1.copyWith(color: valueColor)),
          ],
        )),
      ],
    );
  }
}
