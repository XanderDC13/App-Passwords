import 'package:flutter/material.dart';
import 'package:passwords/screens/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://upcdigdbjukklmohqtig.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVwY2RpZ2RianVra2xtb2hxdGlnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDczMTg2NjksImV4cCI6MjA2Mjg5NDY2OX0.ztgQXTdnsCVAAV-iAnIwTnHFNLwS9QGqL3-99-5dB4I',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: const HomeScreen(),
    );
  }
}
