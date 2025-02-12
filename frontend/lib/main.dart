import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  print("Loaded API_URL: ${dotenv.env['API_URL']}");
  runApp(const MedicalCheckupApp());
}

final String apiUrl = dotenv.env['API_URL'] ?? "API_URL_NOT_FOUND";

class MedicalCheckupApp extends StatelessWidget {
  const MedicalCheckupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Virtual Clinic",
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18.0, color: Colors.black87),
        ),
        cardTheme: CardTheme(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
