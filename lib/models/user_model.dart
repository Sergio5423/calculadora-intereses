import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;        // Será la cédula
  String name;      // Nombre completo
  String email;     // Correo
  String password;  // Contraseña (aunque usamos una por defecto ahora)
  String pin;       // PIN de 4 dígitos

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.pin,
  });

  factory UserModel.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      pin: data['pin'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'pin': pin,
    };
  }
}

