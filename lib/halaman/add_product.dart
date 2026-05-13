import 'package:flutter/material.dart';
import '../model/produk.dart';
import '../service/serviceapi.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() =>
      _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final apiService = Apiservice();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveProduct() async {
    if (
      nameController.text.isEmpty ||
      priceController.text.isEmpty ||
      descriptionController.text.isEmpty
    ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field wajib diisi!'),
          backgroundColor: Color(0xFF7F49B4),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    Produk product = Produk(
      id: 0,
      name: nameController.text,
      price: int.parse(priceController.text),
      description: descriptionController.text,
    );

    bool success = await apiService.addProduk(product);

    if (!mounted) return;
    setState(() => isLoading = false);

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menambahkan produk.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7F49B4),
        title: const Text(
          'Tambah Produk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Informasi Produk',
              style: TextStyle(
                color: Color(0xFF7F49B4),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              style: const TextStyle(color: Color(0xFFCFCFCF)),
              decoration: InputDecoration(
                labelText: 'Nama Produk',
                labelStyle: const TextStyle(color: Color(0xFFCFCFCF)),
                prefixIcon: const Icon(Icons.shopping_bag, color: Color(0xFF7F49B4)),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF7F49B4), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Color(0xFFCFCFCF)),
              decoration: InputDecoration(
                labelText: 'Harga',
                labelStyle: const TextStyle(color: Color(0xFFCFCFCF)),
                prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF7F49B4)),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF7F49B4), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              style: const TextStyle(color: Color(0xFFCFCFCF)),
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                labelStyle: const TextStyle(color: Color(0xFFCFCFCF)),
                prefixIcon: const Icon(Icons.description, color: Color(0xFF7F49B4)),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF7F49B4), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F49B4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                  'Simpan Produk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ) 
    );
  }
}