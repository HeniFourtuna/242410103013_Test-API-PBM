import 'package:flutter/material.dart';
import '../model/produk.dart';
import '../service/serviceapi.dart';
import 'add_product.dart';
import 'detail_produk.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiService = Apiservice();

  List<Produk> products = [];
  List<Produk> filteredProduk = [];
  bool isLoading = false;

  String userName = '';
  String userNim = '';
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
    loadUserInfo();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void loadUserInfo() async {
    final info = await apiService.getUserInfo();
    setState(() {
      userName = info['name'] ?? '';
      userNim = info['username'] ?? '';
    });
  }

  void loadProducts() async {
    setState(() => isLoading = true);
    final result = await apiService.getProduk();
    if (!mounted) return;
    setState(() {
      products = result;
      filteredProduk = result;
      isLoading = false;
    });
  }

  void searchProduk(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProduk = products;
      } else {
        filteredProduk = products
          .where((p) =>
            p.name.toLowerCase().contains(query.toLowerCase()) ||
            p.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
      }
    });
  }

  void _confirmDelete(Produk product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Hapus Produk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Yakin ingin menghapus "${product.name}"?',
          style: const TextStyle(color: Color(0xFFCFCFCF)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Color(0xFFCFCFCF))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              bool success = await apiService.deleteProduk(product.id);
              if (!mounted) return;
              if (success) {
                setState(() {
                  products.remove(product);
                  filteredProduk.remove(product);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Produk berhasil dihapus!'),
                    backgroundColor: Color(0xFF7F49B4),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gagal menghapus produk'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSubmitDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();
    final githubController = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Submit Tugas',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pastikan data benar sebelum submit!\nData tidak bisa diubah setelah submit.',
                  style: TextStyle(color: Color(0xFFCFCFCF), fontSize: 12),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Color(0xFFCFCFCF)),
                  decoration: InputDecoration(
                    labelText: 'Nama Produk',
                    labelStyle: const TextStyle(color: Color(0xFFCFCFCF)),
                    filled: true,
                    fillColor: const Color(0xFF2E2E2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF7F49B4)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Color(0xFFCFCFCF)),
                  decoration: InputDecoration(
                    labelText: 'Harga',
                    labelStyle: const TextStyle(color: Color(0xFFCFCFCF)),
                    filled: true,
                    fillColor: const Color(0xFF2E2E2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF7F49B4)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  style: const TextStyle(color: Color(0xFFCFCFCF)),
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    labelStyle: const TextStyle(color: Color(0xFFCFCFCF)),
                    filled: true,
                    fillColor: const Color(0xFF2E2E2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF7F49B4)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: githubController,
                  style: const TextStyle(color: Color(0xFFCFCFCF)),
                  decoration: InputDecoration(
                    labelText: 'GitHub URL',
                    hintText: 'https://github.com/username/repo',
                    hintStyle: const TextStyle(color: Color(0xFF555555)),
                    labelStyle: const TextStyle(color: Color(0xFFCFCFCF)),
                    prefixIcon: const Icon(Icons.link, color: Color(0xFF7F49B4)),
                    filled: true,
                    fillColor: const Color(0xFF2E2E2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF7F49B4)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: Color(0xFFCFCFCF))),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                ? null
                : () async {
                  if (
                    nameController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    descController.text.isEmpty ||
                    githubController.text.isEmpty
                  ) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Semua field wajib diisi!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  setDialogState(() => isSubmitting = true);

                  bool success = await apiService.submitTugas(
                    name: nameController.text,
                    price: int.parse(priceController.text),
                    description: descController.text,
                    githubUrl: githubController.text,
                  );

                  if (!mounted) return;
                  Navigator.pop(ctx);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                          ? 'Tugas berhasil disubmit!'
                          : 'Tugas gagal disubmit, Harap coba lagi.',
                      ),
                      backgroundColor:
                        success ? const Color(0xFF7F49B4) : Colors.red,
                    ),
                  );
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7F49B4),
              ),
              child: isSubmitting
                ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                : const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7F49B4),
        title: const Text(
          'Katalog Produk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload, color: Colors.white,),
            onPressed: _showSubmitDialog,
            tooltip: 'Submit Tugas',
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12,)
              ),
              child: Text(
                '${filteredProduk.length} produk',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: loadProducts,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E1E1E),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7F49B4),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName.isEmpty ? 'Loading...' : userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      userNim.isEmpty ? '' : 'NIM: $userNim',
                      style: const TextStyle(
                        color: Color(0xFFCFCFCF),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: searchProduk,
              style: const TextStyle(color: Color(0xFFCFCFCF)),
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                hintStyle: const TextStyle(color: Color(0xFF7F49B4)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF7F49B4)),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFFCFCFCF)),
                        onPressed: () {
                          searchController.clear();
                          searchProduk('');
                        },
                      )
                    : null,
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
          ),

          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7F49B4)),
                  )
                : filteredProduk.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_bag_outlined,
                                size: 64, color: Color(0xFF7F49B4)),
                            const SizedBox(height: 16),
                            Text(
                              searchController.text.isNotEmpty
                                  ? 'Produk tidak ditemukan'
                                  : 'Belum ada produk.',
                              style: const TextStyle(
                                color: Color(0xFFCFCFCF),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              searchController.text.isNotEmpty
                                  ? 'Coba kata kunci lain'
                                  : 'Tambah produk dengan tombol +',
                              style: const TextStyle(color: Color(0xFF7F49B4)),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: filteredProduk.length,
                        itemBuilder: (_, index) {
                          final product = filteredProduk[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF7F49B4).withOpacity(0.3),
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailProduk(product: product),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF7F49B4).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.shopping_bag,
                                        color: Color(0xFF7F49B4),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.description,
                                            style: const TextStyle(
                                              color: Color(0xFFCFCFCF),
                                              fontSize: 12,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Rp ${product.price.toString().replaceAllMapped(
                                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                              (m) => '${m[1]}.',
                                            )}',
                                            style: const TextStyle(
                                              color: Color(0xFF7F49B4),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      onPressed: () => _confirmDelete(product),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7F49B4),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductPage()),
          );
          loadProducts();
        },
      ),
    );
  }
}