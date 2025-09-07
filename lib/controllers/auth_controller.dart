import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser({
    required String id,        // cédula
    required String name,      // nombre
    required String email,     // correo
    required String password,  // contraseña
    required String pin, required String telefono, required String accountType, required String accountNumber, required int balance,       // PIN de 4 dígitos
  }) async {
    try {
      // Guardar directamente en Firestore usando la cédula como ID del documento
      await _firestore.collection('users').doc(id).set({
        'name': name,
        'email': email,
        'password': password,
        'pin': pin,
      });

      print("✅ Usuario registrado con cédula $id");

    } catch (e) {
      throw Exception('Error al registrar el usuario: ${e.toString()}');
    }
  }
}
