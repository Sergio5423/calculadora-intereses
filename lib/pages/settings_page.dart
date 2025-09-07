import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  bool highContrast = false;
  bool largeText = false;
  bool reduceMotion = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 📌 Fondo de pantalla
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/home_page.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  // 🔹 Encabezado
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade600, Colors.orange.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "⚙️ Configuración",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Opciones de accesibilidad y personalización",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Opciones
                  _buildSwitchTile(
                    title: "Modo oscuro",
                    subtitle: "Activa un tema oscuro para toda la app",
                    value: darkMode,
                    onChanged: (val) => setState(() => darkMode = val),
                    icon: Icons.dark_mode,
                    color: Colors.black,
                  ),
                  _buildSwitchTile(
                    title: "Alto contraste",
                    subtitle: "Mejora la legibilidad de los textos",
                    value: highContrast,
                    onChanged: (val) => setState(() => highContrast = val),
                    icon: Icons.contrast,
                    color: Colors.purple,
                  ),
                  _buildSwitchTile(
                    title: "Texto grande",
                    subtitle: "Aumenta el tamaño de las fuentes",
                    value: largeText,
                    onChanged: (val) => setState(() => largeText = val),
                    icon: Icons.format_size,
                    color: Colors.blue,
                  ),
                  _buildSwitchTile(
                    title: "Reducir animaciones",
                    subtitle: "Minimiza los efectos visuales",
                    value: reduceMotion,
                    onChanged: (val) => setState(() => reduceMotion = val),
                    icon: Icons.motion_photos_off,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Widget reutilizable para switches
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: color,
        secondary: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
        ),
      ),
    );
  }
}
