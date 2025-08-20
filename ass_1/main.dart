import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/login_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://wluwjsyglxefuxnmuixh.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndsdXdqc3lnbHhlZnV4bm11aXhoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQzNjM0NDEsImV4cCI6MjA2OTkzOTQ0MX0.48YQ-NV-SjFFM_nt9gIGXkTOo7Ege8eCcincSSe-GZA",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
