import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'interest_page.dart';
import 'simple_interest_page.dart';
import 'compound_interest_page.dart';
import 'annuity_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: color ?? Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(icon, size: 32, color: Colors.green.shade700),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  // 📌 Pantallas para cada tab
  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const ProfilePage(); // 🟢 Nueva página de perfil
      case 2:
        return const SettingsPage(); // ⚙️ Nueva página de configuración
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Stack(
      children: [
        // Fondo
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/home_page.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Contenido
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // Header moderno
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade700, Colors.green.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "📊 Calculadora Financiera",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Seleccione una opción para comenzar",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Opciones
                _buildOptionCard(
                  icon: Icons.percent,
                  title: "Tasa de Interés",
                  description:
                      "Convierte entre tasa nominal, efectiva y periódica",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InterestPage()),
                    );
                  },
                  color: Colors.green.shade50,
                ),
                _buildOptionCard(
                  icon: Icons.calculate,
                  title: "Interés Simple",
                  description: "Calcula el monto futuro, tasa o tiempo",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SimpleInterestPage()),
                    );
                  },
                  color: Colors.blue.shade50,
                ),
                _buildOptionCard(
                  icon: Icons.show_chart,
                  title: "Interés Compuesto",
                  description:
                      "Simula el crecimiento del capital con capitalización",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CompoundInterestPage()),
                    );
                  },
                  color: Colors.orange.shade50,
                ),
                _buildOptionCard(
                  icon: Icons.account_balance_wallet,
                  title: "Anualidades",
                  description:
                      "Calcula el valor presente y futuro de pagos periódicos",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AnnuityPage()),
                    );
                  },
                  color: Colors.purple.shade50,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Inicio"),
            selectedColor: Colors.green.shade700,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Perfil"),
            selectedColor: Colors.blue.shade600,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: const Text("Configuración"),
            selectedColor: Colors.orange.shade600,
          ),
        ],
      ),
    );
  }
}
