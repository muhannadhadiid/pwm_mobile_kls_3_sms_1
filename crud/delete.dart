import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PageItems extends StatefulWidget {
  const PageItems({super.key});

  @override
  State<PageItems> createState() => _PageItemsState();
}

class _PageItemsState extends State<PageItems> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final response = await supabase
          .from('items')
          .select('id, name') // pastikan ambil id untuk delete
          .order('name', ascending: true);
      setState(() {
        items = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching items: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await supabase.from('items').delete().eq('id', id);
      fetchItems(); // refresh list setelah delete
    } catch (e) {
      debugPrint('Error deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : items.isEmpty
              ? const Center(child: Text('No data found'))
              : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item['name']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteItem(item['id']);
                      },
                    ),
                  );
                },
              ),
    );
  }
}
