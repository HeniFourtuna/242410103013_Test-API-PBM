import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/produk.dart';

class Apiservice {
  static const String baseUrl =
    'https://task.itprojects.web.id/api';
  
  final storage = FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if  (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      String token = data['data']['token'];
      String name = data['data']['user']['name'];
      String nim = data['data']['user']['username'];

      await storage.write(
        key: 'token',
        value: token,
      );
      await storage.write(key: 'name', value: name);
      await storage.write(key: 'username', value: nim);

      return true;
    }

    return false;
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<List<Produk>> getProduk() async {
    String? token = await getToken();

    final url = Uri.parse('$baseUrl/products');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List products = data['data']['products'];

      return products
        .map((e) => Produk.fromJson(e))
        .toList();
    }

    return [];
  }
  
  Future<bool> addProduk(Produk products) async {
    String? token =await getToken();

    final url = Uri.parse('$baseUrl/products');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(products.tojson()),
    );

    return response.statusCode == 201;
  }

  Future<bool> submitTugas({
    required String name,
    required int price,
    required String description,
    required String githubUrl,
  }) async {
    String? token = await getToken();

    final url = Uri.parse('$baseUrl/products/submit');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
        'github_url': githubUrl,
      }),
    );

    return response.statusCode == 201;
  }

  Future<bool> deleteProduk(int id) async {
    String? token = await getToken();
    final url = Uri.parse('$baseUrl/products/$id');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<Map<String, String>> getUserInfo() async {
    String? name = await storage.read(key: 'name');
    String? username = await storage.read(key: 'username');
    return {
      'name': name ?? '',
      'username': username ?? '',
    };
  }
}