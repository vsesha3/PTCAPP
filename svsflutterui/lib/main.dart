import 'package:flutter/material.dart';
import 'package:svsflutterui/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:svsflutterui/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Grooming Tales',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            background: Colors.white,
            surface: Colors.white,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          cardTheme: const CardTheme(
            color: Colors.white,
          ),
          dialogTheme: const DialogTheme(
            backgroundColor: Colors.white,
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
