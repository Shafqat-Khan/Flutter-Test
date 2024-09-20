import 'dart:convert';
import 'package:http/http.dart' as http;

// service to fetch products 
class ProductService {
  Future<List<String>> fetchProductNames() async {
    final response =
        await http.get(Uri.parse('https://app.giotheapp.com/api-sample/'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<String> productNames = data.values.cast<String>().toList();
      return productNames;
    } else {
      print('Failed to load products: ${response.statusCode}');
      throw Exception('Failed to load products');
    }
  }
}
