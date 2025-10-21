import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleInterestPage extends StatefulWidget {
  const SimpleInterestPage({super.key});

  @override
  State<SimpleInterestPage> createState() => _SimpleInterestPageState();
}

class _SimpleInterestPageState extends State<SimpleInterestPage> {
  final capitalCtrl = TextEditingController();
  final tasaCtrl = TextEditingController();
  final montoCtrl = TextEditingController();
  final periodosCtrl = TextEditingController();

  String calcular = 'Monto Futuro';
  String unidad = 'meses';
  String resultado = '';
  String ejemplo = '';
  String teoriaYFormula = ''; // Nueva variable para teoría y fórmulas

  @override
  void initState() {
    super.initState();
    _cargarEjemplo(calcular); // 👉 ejemplo por defecto al abrir la página
    _cargarTeoriaYFormula(calcular); // 👉 teoría y fórmula por defecto
  }

  void _cargarEjemplo(String tipo) {
    switch (tipo) {
      case 'Monto Futuro':
        ejemplo =
            'Ejemplo: Si inviertes \$1,000,000 COP al 2% mensual por 6 meses,\n'
            'el interés será de \$120,000 COP y el monto final de \$1,120,000 COP.';
        break;
      case 'Tasa de Interés':
        ejemplo =
            'Ejemplo: Si un capital de \$1,000,000 COP crece a \$1,120,000 en 6 meses,\n'
            'la tasa de interés simple mensual es ≈ 2%.';
        break;
      case 'Tiempo':
        ejemplo =
            'Ejemplo: Para que \$1,000,000 COP se conviertan en \$1,120,000 COP\n'
            'a una tasa del 2% mensual, se requieren 6 meses.';
        break;
    }
  }

  void _cargarTeoriaYFormula(String tipo) {
    switch (tipo) {
      case 'Monto Futuro':
        teoriaYFormula = "TEORÍA DEL INTERÉS SIMPLE\n\n"
            "• Pago por el uso de dinero prestado\n"
            "• Se calcula sobre el capital inicial (principal)\n"
            "• No hay capitalización de intereses\n"
            "• Los intereses no generan más intereses\n\n"
            "FÓRMULAS DEL INTERÉS SIMPLE\n\n"
            "Interés Simple:\n"
            "I = C × i × t\n\n"
            "Monto Futuro:\n"
            "M = C + I\n"
            "M = C × (1 + i × t)\n\n"
            "Donde:\n"
            "• I = Interés Simple\n"
            "• C = Capital inicial\n"
            "• i = Tasa de interés por período\n"
            "• t = Tiempo (en períodos)\n"
            "• M = Monto Futuro";
        break;

      case 'Tasa de Interés':
        teoriaYFormula = "TEORÍA DEL INTERÉS SIMPLE\n\n"
            "CARACTERÍSTICAS:\n"
            "• El interés se calcula siempre sobre el capital original\n"
            "• La tasa se aplica sobre el mismo capital en cada período\n"
            "• Los intereses son constantes en cada período\n"
            "• Fácil de calcular y entender\n\n"
            "FÓRMULAS PARA CALCULAR LA TASA\n\n"
            "De: I = C × i × t\n"
            "Despejando i:\n"
            "i = I / (C × t)\n\n"
            "También:\n"
            "i = (M - C) / (C × t)\n\n"
            "Donde:\n"
            "• i = Tasa de interés\n"
            "• I = Interés total (M - C)\n"
            "• C = Capital inicial\n"
            "• M = Monto Futuro\n"
            "• t = Tiempo en períodos";
        break;

      case 'Tiempo':
        teoriaYFormula = "TEORÍA DEL INTERÉS SIMPLE\n\n"
            "CONVERSIÓN DE TIEMPO:\n"
            "• 1 año = 12 meses\n"
            "• 1 año = 360 días (comercial)\n"
            "• 6 meses = 0.5 años\n"
            "• 90 días = 90/360 = 0.25 años\n\n"
            "FÓRMULAS PARA CALCULAR EL TIEMPO\n\n"
            "De: I = C × i × t\n"
            "Despejando t:\n"
            "t = I / (C × i)\n\n"
            "También:\n"
            "t = (M - C) / (C × i)\n\n"
            "Donde:\n"
            "• t = Tiempo en períodos\n"
            "• I = Interés total (M - C)\n"
            "• C = Capital inicial\n"
            "• M = Monto Futuro\n"
            "• i = Tasa de interés por período";
        break;
    }
  }

  void _calcular() {
    final C = double.tryParse(capitalCtrl.text) ?? 0.0;
    final iPct = double.tryParse(tasaCtrl.text) ?? 0.0;
    final M = double.tryParse(montoCtrl.text) ?? 0.0;
    final n = double.tryParse(periodosCtrl.text) ?? 0.0;

    final i = iPct / 100;

    switch (calcular) {
      case 'Monto Futuro':
        final I = C * i * n;
        final MF = C + I;
        resultado =
            'Interés generado: \$${I.toStringAsFixed(2)} COP\nMonto Futuro (M): \$${MF.toStringAsFixed(2)} COP';
        break;

      case 'Tasa de Interés':
        if (C > 0 && n > 0) {
          final tasa = ((M - C) / (C * n)) * 100;
          resultado = 'Tasa de interés (i): ${tasa.toStringAsFixed(2)}%';
        }
        break;

      case 'Tiempo':
        if (C > 0 && i > 0) {
          final tiempo = (M - C) / (C * i);
          resultado = 'Tiempo necesario (n): ${tiempo.toStringAsFixed(2)} $unidad';
        }
        break;
    }
    setState(() {}); // 👉 refresca tanto resultado como ejemplo
  }

  Widget _buildCampos() {
    switch (calcular) {
      case 'Monto Futuro':
        return Column(
          children: [
            _input(capitalCtrl, 'Capital (C)'),
            const SizedBox(height: 12),
            _input(tasaCtrl, 'Tasa i (%) por periodo'),
            const SizedBox(height: 12),
            _input(periodosCtrl, 'Número de periodos (n)'),
          ],
        );
      case 'Tasa de Interés':
        return Column(
          children: [
            _input(capitalCtrl, 'Capital (C)'),
            const SizedBox(height: 12),
            _input(montoCtrl, 'Monto Futuro (M)'),
            const SizedBox(height: 12),
            _input(periodosCtrl, 'Número de periodos (n)'),
          ],
        );
      case 'Tiempo':
        return Column(
          children: [
            _input(capitalCtrl, 'Capital (C)'),
            const SizedBox(height: 12),
            _input(montoCtrl, 'Monto Futuro (M)'),
            const SizedBox(height: 12),
            _input(tasaCtrl, 'Tasa i (%) por periodo'),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _input(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: TextInputType.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle =
        GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18);

    return Scaffold(
      appBar: AppBar(
        title: Text('Interés Simple',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Calculadora de Interés Simple',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800)),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: calcular,
            items: const [
              DropdownMenuItem(value: 'Monto Futuro', child: Text('Calcular Monto Futuro')),
              DropdownMenuItem(value: 'Tasa de Interés', child: Text('Calcular Tasa de Interés')),
              DropdownMenuItem(value: 'Tiempo', child: Text('Calcular Tiempo')),
            ],
            onChanged: (v) => setState(() {
              calcular = v ?? 'Monto Futuro';
              resultado = '';
              _cargarEjemplo(calcular); // 👉 actualiza el ejemplo automáticamente
              _cargarTeoriaYFormula(calcular); // 👉 actualiza teoría y fórmula
              capitalCtrl.clear();
              tasaCtrl.clear();
              montoCtrl.clear();
              periodosCtrl.clear();
            }),
            decoration: const InputDecoration(labelText: '¿Qué deseas calcular?'),
          ),

          const SizedBox(height: 20),
          _buildCampos(),

          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _calcular,
            icon: const Icon(Icons.calculate),
            label: Text("Calcular",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),

          const SizedBox(height: 20),
          if (resultado.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                resultado,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900),
              ),
            ),

          // 🔹 NUEVA SECCIÓN: Teoría y Fórmulas
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text(
              teoriaYFormula,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.blue.shade900,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Text(
              ejemplo,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}