import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

// Páginas
import 'package:auth_2024/pages/login_page.dart';
import 'package:auth_2024/pages/register_page.dart';
import 'package:auth_2024/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Inicializa Firebase dependiendo si es web o no
  if (GetPlatform.isWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD9ovsb5MZ6GcOcCTp9fMDuOWT0dJPfjI0",
        authDomain: "proyecto01-6cccd.firebaseapp.com",
        projectId: "proyecto01-6cccd",
        storageBucket: "proyecto01-6cccd.appspot.com",
        messagingSenderId: "641718329705",
        appId: "1:641718329705:web:90b1638b10a0dced47ddf8",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ingeniería Económica',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // Material 3 activado
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(), // 👈 Fuente moderna aplicada
      ),
      initialRoute: '/login', // LoginPage será la pantalla inicial
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(
            name: '/home', page: () => const HomePage()), // 👈 Ruta agregada
      ],
    );
  }
}
