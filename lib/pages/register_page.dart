import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  void registerUser() async {
    String cedula = cedulaController.text.trim();
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String pin = pinController.text.trim();

    if (cedula.isEmpty || name.isEmpty || email.isEmpty || pin.isEmpty) {
      _showMessage('⚠️ Por favor completa todos los campos');
      return;
    }

    if (!RegExp(r'^\d{6,10}$').hasMatch(cedula)) {
      _showMessage('⚠️ La cédula debe tener entre 6 y 10 dígitos');
      return;
    }

    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(name)) {
      _showMessage('⚠️ El nombre solo puede contener letras');
      return;
    }

    if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(email)) {
      _showMessage('⚠️ Correo electrónico inválido');
      return;
    }

    if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
      _showMessage('⚠️ El PIN debe tener exactamente 4 dígitos');
      return;
    }

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Verificar duplicados
      var existingUser = await firestore.collection('users').doc(cedula).get();
      if (existingUser.exists) {
        _showMessage('❌ Ya existe un usuario con esta cédula');
        return;
      }

      var emailQuery =
          await firestore.collection('users').where('email', isEqualTo: email).get();
      if (emailQuery.docs.isNotEmpty) {
        _showMessage('❌ Este correo ya está registrado');
        return;
      }

      // Registrar usuario
      await AuthController().registerUser(
        id: cedula,
        name: name,
        email: email,
        telefono: '',
        accountType: 'default',
        accountNumber: '',
        password: '12345678',
        balance: 0,
        pin: pin,
      );

      _showMessage('✅ Registro exitoso');
      cedulaController.clear();
      nameController.clear();
      emailController.clear();
      pinController.clear();
    } catch (e) {
      _showMessage('❌ Error en el registro: $e');
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.poppins()),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.green.shade700),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/register_and_login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_add_alt_1,
                      size: 80, color: Colors.green.shade700),
                  const SizedBox(height: 12),
                  Text(
                    "Registro de Usuario",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  const SizedBox(height: 25),

                  _input(cedulaController, "Cédula", Icons.badge, TextInputType.number),
                  const SizedBox(height: 12),
                  _input(nameController, "Nombre completo", Icons.person, TextInputType.name),
                  const SizedBox(height: 12),
                  _input(emailController, "Correo electrónico", Icons.email,
                      TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  _input(pinController, "PIN (4 dígitos)", Icons.lock, TextInputType.number,
                      obscure: true, maxLength: 4),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: registerUser,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      label: Text(
                        "Registrar",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "¿Ya tienes cuenta? Inicia sesión",
                      style: GoogleFonts.poppins(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController ctrl, String label, IconData icon,
      TextInputType type,
      {bool obscure = false, int? maxLength}) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      maxLength: maxLength,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        hintText: "Ingrese $label",
        labelStyle: GoogleFonts.poppins(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}

