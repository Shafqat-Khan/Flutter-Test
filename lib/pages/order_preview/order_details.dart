import 'package:flutter/material.dart';
import 'package:flutter_assesment/pages/order_preview/order_detail_row.dart';
import 'package:flutter_assesment/themes/theme.dart';

class OrderDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Image(
          image: AssetImage('assets/icons/logo.png'),
          height: 110,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OrderDetailRow(
              label: 'Order #',
              value: '112096',
              labelColor: AppTheme.secondaryColor,
              valueColor: AppTheme.primaryColor,
            ),
            const SizedBox(height: 10),
            const OrderDetailRow(
              label: 'Order name',
              value: 'Joe’s catering',
              labelColor: AppTheme.secondaryColor,
              valueColor: AppTheme.primaryColor,
              subLabel1: 'optional',
            ),
            const SizedBox(height: 10),
            const OrderDetailRow(
              label: 'Delivery date',
              value: 'May 4th 2024',
              labelColor: AppTheme.secondaryColor,
              valueColor: AppTheme.primaryColor,
            ),
            const SizedBox(height: 10),
            const OrderDetailRow(
              label: 'Total quantity',
              value: '38',
              labelColor: AppTheme.secondaryColor,
              valueColor: Colors.black,
            ),
            const SizedBox(height: 10),
            const OrderDetailRow(
              label: 'Estimated total',
              value: '\$1402.96',
              labelColor: AppTheme.secondaryColor,
              valueColor: Colors.black,
            ),
            const SizedBox(height: 10),
            const OrderDetailRow(
              label: 'Location',
              value: '355 Onderdonk St\nMarina Dubai, UAE',
              labelColor: AppTheme.secondaryColor,
              valueColor: Colors.black,
              subLabel2: 'Deliver to:',
            ),
            const SizedBox(height: 20),
            Text(
              'Delivery instructions ...',
              style: AppTheme.textStyle5.copyWith(color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: AppTheme.primaryColor,
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: Center(
                  child: Text(
                'submit',
                style: AppTheme.textStyle4.copyWith(color: Colors.white),
              )),
            ),
            const SizedBox(height: 20),
            Text(
              'Save as draft',
              style: AppTheme.textStyle5.copyWith(color: AppTheme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
