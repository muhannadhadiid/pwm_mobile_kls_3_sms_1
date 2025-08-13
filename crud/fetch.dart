import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PageInstruments extends StatefulWidget {
  const PageInstruments({super.key});

  @override
  State<PageInstruments> createState() => _PageInstrumentsState();
}

class _PageInstrumentsState extends State<PageInstruments> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> instruments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInstruments();
  }

  Future<void> fetchInstruments() async {
    try {
      final response = await supabase.from('instruments').select();
      setState(() {
        instruments = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching instruments: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instruments')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : instruments.isEmpty
              ? const Center(child: Text('No data found'))
              : ListView.builder(
                itemCount: instruments.length,
                itemBuilder: (context, index) {
                  final item = instruments[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(item['id'].toString())),
                    title: Text(item['name']),
                  );
                },
              ),
    );
  }
}
