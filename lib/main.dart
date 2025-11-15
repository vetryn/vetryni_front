// main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ihqnnajavcaotnwbqpmq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlocW5uYWphdmNhb3Rud2JxcG1xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMyMjgyMzIsImV4cCI6MjA3ODgwNDIzMn0.UibqM-qp_O1OM5hVMTRbRL5DW9xAsWThtLg-pMHE0fM',
  );

  final subdomain = Uri.base.host.split('.').first;
  final store = await fetchStore(subdomain);

  runApp(VetryniApp(store: store));
}

Future<Map<String, dynamic>> fetchStore(String subdomain) async {
  final response = await Supabase.instance.client.from('tenants').select('name, primary_color').eq('slug', subdomain).maybeSingle();

  if (response == null) {
    return {'name': 'Loja não encontrada', 'primary_color': '#607D8B'};
  }

  return response;
}

class VetryniApp extends StatelessWidget {
  final Map<String, dynamic> store;

  const VetryniApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final primaryColor = _hexToColor(store['primary_color'] ?? '#607D8B');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: store['name'],
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: primaryColor), useMaterial3: true),
      home: HomePage(storeName: store['name']),
    );
  }

  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class HomePage extends StatelessWidget {
  final String storeName;

  const HomePage({super.key, required this.storeName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(storeName, style: TextStyle(color: theme.colorScheme.onPrimary)),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Center(
        child: Text('Bem-vindo à $storeName!', style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.primary)),
      ),
    );
  }
}
