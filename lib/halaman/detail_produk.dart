import 'package:flutter/material.dart';
import '../model/produk.dart';

class DetailProduk extends StatelessWidget {
  final Produk product;

  const DetailProduk({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7F49B4),
        title: const Text(
          'Detail Produk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ikon produk
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF7F49B4).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  color: Color(0xFF7F49B4),
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Nama Produk',
                style: TextStyle(color: Color(0xFF7F49B4), fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              product.name,
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(color: Color(0xFF2E2E2E), height: 32),

            const Text('Harga',
                style: TextStyle(color: Color(0xFF7F49B4), fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              'Rp ${product.price.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (m) => '${m[1]}.',
              )}',
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(color: Color(0xFF2E2E2E), height: 32),

            const Text('Deskripsi',
                style: TextStyle(color: Color(0xFF7F49B4), fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              product.description,
              style: const TextStyle(color: Color(0xFFCFCFCF), fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}