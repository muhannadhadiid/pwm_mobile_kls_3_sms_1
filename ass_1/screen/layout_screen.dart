import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LayoutScreen extends StatefulWidget {
  final String userName;
  const LayoutScreen({super.key, required this.userName});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> hewanList = [];

  @override
  void initState() {
    super.initState();
    fetchHewan();
  }

  Future<void> fetchHewan() async {
    final response = await supabase.from('hewan').select().order('id');
    setState(() {
      hewanList = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> tambahHewan(String nama) async {
    await supabase.from('hewan').insert({'nama': nama});
    fetchHewan();
  }

  Future<void> hapusHewan(int id) async {
    await supabase.from('hewan').delete().eq('id', id);
    fetchHewan();
  }

  void showTambahDialog() {
    String namaHewan = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Hewan'),
          content: TextField(
            decoration: const InputDecoration(labelText: "Nama Hewan"),
            onChanged: (value) => namaHewan = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (namaHewan.trim().isNotEmpty) {
                  tambahHewan(namaHewan);
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi Hapus'),
            content: const Text('Apakah kamu yakin ingin menghapus hewan ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  hapusHewan(id);
                  Navigator.pop(context);
                },
                child: const Text('Hapus'),
              ),
            ],
          ),
    );
  }

  void logout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi Logout'),
            content: const Text('Apakah kamu yakin ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('Ya'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: logout,
          ),
        ],
      ),
      body:
          hewanList.isEmpty
              ? const Center(child: Text('Belum ada data hewan'))
              : ListView.builder(
                itemCount: hewanList.length,
                itemBuilder: (context, index) {
                  final item = hewanList[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(item['id'].toString())),
                    title: Text(item['nama']),
                    subtitle: Text(item['created_at'].toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => showDeleteDialog(item['id']),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah Hewan',
        child: const Icon(Icons.add),
        onPressed: showTambahDialog,
      ),
    );
  }
}
