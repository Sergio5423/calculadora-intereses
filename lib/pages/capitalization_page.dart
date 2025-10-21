import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class CapitalizationPage extends StatefulWidget {
  const CapitalizationPage({super.key});

  @override
  State<CapitalizationPage> createState() => _CapitalizationPageState();
}

class _CapitalizationPageState extends State<CapitalizationPage> {
  final capitalCtrl = TextEditingController(); // C - Capital inicial
  final tasaCtrl = TextEditingController(); // i - Tasa
  final periodosCtrl = TextEditingController(); // n - Periodos
  final montoCtrl = TextEditingController(); // M - Monto futuro

  String calcular = 'Monto Futuro Simple';
  String resultado = '';
  String ejemplo = '';
  String teoriaYFormula = '';

  @override
  void initState() {
    super.initState();
    _cargarEjemplo(calcular);
    _cargarTeoriaYFormula(calcular);
  }

  void _cargarEjemplo(String tipo) {
    switch (tipo) {
      case 'Monto Futuro Simple':
        ejemplo = 'Ejemplo: Capital \$5,000 al 8% anual por 4 años.\n'
            'M = 5000 × (1 + 0.08 × 4) = \$6,600.00\n'
            'Interés total: \$1,600.00';
        break;
      case 'Monto Futuro Compuesto':
        ejemplo = 'Ejemplo: Capital \$5,000 al 8% anual por 4 años.\n'
            'M = 5000 × (1.08)⁴ = \$6,802.44\n'
            'Interés total: \$1,802.44';
        break;
      case 'Capital Inicial Simple':
        ejemplo = 'Ejemplo: Monto futuro \$6,600 al 8% anual por 4 años.\n'
            'C = 6600 / (1 + 0.08 × 4) = \$5,000.00';
        break;
      case 'Capital Inicial Compuesto':
        ejemplo = 'Ejemplo: Monto futuro \$6,802.44 al 8% anual por 4 años.\n'
            'C = 6802.44 / (1.08)⁴ = \$5,000.00';
        break;
      case 'Tasa de Interés Simple':
        ejemplo = 'Ejemplo: Capital \$5,000 crece a \$6,600 en 4 años.\n'
            'i = (6600/5000 - 1) / 4 = 8% anual';
        break;
      case 'Tasa de Interés Compuesto':
        ejemplo = 'Ejemplo: Capital \$5,000 crece a \$6,802.44 en 4 años.\n'
            'i = (6802.44/5000)^(1/4) - 1 = 8% anual';
        break;
      case 'Tiempo Simple':
        ejemplo = 'Ejemplo: Capital \$5,000 al 8% anual para llegar a \$6,600.\n'
            'n = (6600/5000 - 1) / 0.08 = 4 años';
        break;
      case 'Tiempo Compuesto':
        ejemplo = 'Ejemplo: Capital \$5,000 al 8% anual para llegar a \$6,802.44.\n'
            'n = log(6802.44/5000) / log(1.08) = 4 años';
        break;
    }
  }

  void _cargarTeoriaYFormula(String tipo) {
    switch (tipo) {
      case 'Monto Futuro Simple':
        teoriaYFormula = "CAPITALIZACIÓN SIMPLE\n\n"
            "DEFINICIÓN:\n"
            "• Los intereses no se reinvierten\n"
            "• Interés calculado siempre sobre capital inicial\n"
            "• Crecimiento lineal del capital\n\n"
            "FÓRMULA MONTO FUTURO:\n"
            "M = C × (1 + i × n)\n\n"
            "Donde:\n"
            "• M = Monto futuro\n"
            "• C = Capital inicial\n"
            "• i = Tasa de interés por período\n"
            "• n = Número de períodos";
        break;

      case 'Monto Futuro Compuesto':
        teoriaYFormula = "CAPITALIZACIÓN COMPUESTA\n\n"
            "DEFINICIÓN:\n"
            "• Los intereses se reinvierten\n"
            "• Interés sobre interés (anatocismo)\n"
            "• Crecimiento exponencial del capital\n\n"
            "FÓRMULA MONTO FUTURO:\n"
            "M = C × (1 + i)ⁿ\n\n"
            "Donde:\n"
            "• M = Monto futuro\n"
            "• C = Capital inicial\n"
            "• i = Tasa de interés por período\n"
            "• n = Número de períodos";
        break;

      case 'Capital Inicial Simple':
        teoriaYFormula = "CAPITALIZACIÓN SIMPLE\n\n"
            "CARACTERÍSTICAS:\n"
            "• Fácil de calcular\n"
            "• Interés constante por período\n"
            "• Usado en operaciones a corto plazo\n\n"
            "FÓRMULA CAPITAL INICIAL:\n"
            "C = M / (1 + i × n)\n\n"
            "Donde:\n"
            "• C = Capital inicial a calcular\n"
            "• M = Monto futuro conocido\n"
            "• i = Tasa de interés\n"
            "• n = Número de períodos";
        break;

      case 'Capital Inicial Compuesto':
        teoriaYFormula = "CAPITALIZACIÓN COMPUESTA\n\n"
            "CARACTERÍSTICAS:\n"
            "• Interés compuesto\n"
            "• Crecimiento exponencial\n"
            "• Usado en inversiones a largo plazo\n\n"
            "FÓRMULA CAPITAL INICIAL:\n"
            "C = M / (1 + i)ⁿ\n\n"
            "Donde:\n"
            "• C = Capital inicial a calcular\n"
            "• M = Monto futuro conocido\n"
            "• i = Tasa de interés\n"
            "• n = Número de períodos";
        break;

      case 'Tasa de Interés Simple':
        teoriaYFormula = "CAPITALIZACIÓN SIMPLE\n\n"
            "APLICACIONES:\n"
            "• Préstamos a corto plazo\n"
            "• Descuentos comerciales\n"
            "• Cálculos financieros simples\n\n"
            "FÓRMULA TASA DE INTERÉS:\n"
            "i = (M/C - 1) / n\n\n"
            "Donde:\n"
            "• i = Tasa de interés a calcular\n"
            "• M = Monto futuro\n"
            "• C = Capital inicial\n"
            "• n = Número de períodos";
        break;

      case 'Tasa de Interés Compuesto':
        teoriaYFormula = "CAPITALIZACIÓN COMPUESTA\n\n"
            "APLICACIONES:\n"
            "• Inversiones a largo plazo\n"
            "• Fondos de pensiones\n"
            "• Planes de ahorro\n\n"
            "FÓRMULA TASA DE INTERÉS:\n"
            "i = (M/C)^(1/n) - 1\n\n"
            "Donde:\n"
            "• i = Tasa de interés a calcular\n"
            "• M = Monto futuro\n"
            "• C = Capital inicial\n"
            "• n = Número de períodos";
        break;

      case 'Tiempo Simple':
        teoriaYFormula = "CAPITALIZACIÓN SIMPLE\n\n"
            "CONSIDERACIONES:\n"
            "• Tiempo en misma unidad que tasa\n"
            "• Resultado exacto en períodos\n"
            "• Fórmula lineal\n\n"
            "FÓRMULA TIEMPO:\n"
            "n = (M/C - 1) / i\n\n"
            "Donde:\n"
            "• n = Tiempo a calcular\n"
            "• M = Monto futuro\n"
            "• C = Capital inicial\n"
            "• i = Tasa de interés";
        break;

      case 'Tiempo Compuesto':
        teoriaYFormula = "CAPITALIZACIÓN COMPUESTA\n\n"
            "CONSIDERACIONES:\n"
            "• Usa logaritmos para cálculo\n"
            "• Tiempo puede ser decimal\n"
            "• Crecimiento exponencial\n\n"
            "FÓRMULA TIEMPO:\n"
            "n = log(M/C) / log(1 + i)\n\n"
            "Donde:\n"
            "• n = Tiempo a calcular\n"
            "• M = Monto futuro\n"
            "• C = Capital inicial\n"
            "• i = Tasa de interés\n"
            "• log = Logaritmo natural o base 10";
        break;
    }
  }

  void _calcular() {
    final C = double.tryParse(capitalCtrl.text) ?? 0.0;
    final iPct = double.tryParse(tasaCtrl.text) ?? 0.0;
    final n = double.tryParse(periodosCtrl.text) ?? 0.0;
    final M = double.tryParse(montoCtrl.text) ?? 0.0;

    final i = iPct / 100;

    try {
      switch (calcular) {
        case 'Monto Futuro Simple':
          final monto = C * (1 + i * n);
          final interes = monto - C;
          resultado = 'Monto Futuro (M): \$${monto.toStringAsFixed(2)}\n'
                      'Interés total: \$${interes.toStringAsFixed(2)}';
          break;

        case 'Monto Futuro Compuesto':
          final monto = C * pow(1 + i, n);
          final interes = monto - C;
          resultado = 'Monto Futuro (M): \$${monto.toStringAsFixed(2)}\n'
                      'Interés total: \$${interes.toStringAsFixed(2)}';
          break;

        case 'Capital Inicial Simple':
          final capital = M / (1 + i * n);
          resultado = 'Capital Inicial (C): \$${capital.toStringAsFixed(2)}';
          break;

        case 'Capital Inicial Compuesto':
          final capital = M / pow(1 + i, n);
          resultado = 'Capital Inicial (C): \$${capital.toStringAsFixed(2)}';
          break;

        case 'Tasa de Interés Simple':
          final tasa = ((M / C) - 1) / n * 100;
          resultado = 'Tasa de interés (i): ${tasa.toStringAsFixed(2)}%';
          break;

        case 'Tasa de Interés Compuesto':
          final tasa = (pow(M / C, 1 / n) - 1) * 100;
          resultado = 'Tasa de interés (i): ${tasa.toStringAsFixed(2)}%';
          break;

        case 'Tiempo Simple':
          final tiempo = ((M / C) - 1) / i;
          resultado = 'Tiempo necesario (n): ${tiempo.toStringAsFixed(2)} períodos';
          break;

        case 'Tiempo Compuesto':
          final tiempo = log(M / C) / log(1 + i);
          resultado = 'Tiempo necesario (n): ${tiempo.toStringAsFixed(2)} períodos';
          break;
      }
      setState(() {});
    } catch (e) {
      setState(() {
        resultado = 'Error en el cálculo: $e';
      });
    }
  }

  Widget _input(TextEditingController ctrl, String label, {String hint = ''}) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildCampos() {
    switch (calcular) {
      case 'Monto Futuro Simple':
      case 'Monto Futuro Compuesto':
        return Column(
          children: [
            _input(capitalCtrl, 'Capital inicial (C)', hint: 'Ej: 5000'),
            const SizedBox(height: 12),
            _input(tasaCtrl, 'Tasa i (%) por periodo', hint: 'Ej: 8'),
            const SizedBox(height: 12),
            _input(periodosCtrl, 'Número de periodos (n)', hint: 'Ej: 4'),
          ],
        );

      case 'Capital Inicial Simple':
      case 'Capital Inicial Compuesto':
        return Column(
          children: [
            _input(montoCtrl, 'Monto futuro (M)', hint: 'Ej: 6802.44'),
            const SizedBox(height: 12),
            _input(tasaCtrl, 'Tasa i (%) por periodo', hint: 'Ej: 8'),
            const SizedBox(height: 12),
            _input(periodosCtrl, 'Número de periodos (n)', hint: 'Ej: 4'),
          ],
        );

      case 'Tasa de Interés Simple':
      case 'Tasa de Interés Compuesto':
        return Column(
          children: [
            _input(capitalCtrl, 'Capital inicial (C)', hint: 'Ej: 5000'),
            const SizedBox(height: 12),
            _input(montoCtrl, 'Monto futuro (M)', hint: 'Ej: 6802.44'),
            const SizedBox(height: 12),
            _input(periodosCtrl, 'Número de periodos (n)', hint: 'Ej: 4'),
          ],
        );

      case 'Tiempo Simple':
      case 'Tiempo Compuesto':
        return Column(
          children: [
            _input(capitalCtrl, 'Capital inicial (C)', hint: 'Ej: 5000'),
            const SizedBox(height: 12),
            _input(montoCtrl, 'Monto futuro (M)', hint: 'Ej: 6802.44'),
            const SizedBox(height: 12),
            _input(tasaCtrl, 'Tasa i (%) por periodo', hint: 'Ej: 8'),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistemas de Capitalización',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Calculadora de Capitalización',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan.shade800)),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: calcular,
            items: const [
              DropdownMenuItem(value: 'Monto Futuro Simple', child: Text('Monto Futuro Simple')),
              DropdownMenuItem(value: 'Monto Futuro Compuesto', child: Text('Monto Futuro Compuesto')),
              DropdownMenuItem(value: 'Capital Inicial Simple', child: Text('Capital Inicial Simple')),
              DropdownMenuItem(value: 'Capital Inicial Compuesto', child: Text('Capital Inicial Compuesto')),
              DropdownMenuItem(value: 'Tasa de Interés Simple', child: Text('Tasa de Interés Simple')),
              DropdownMenuItem(value: 'Tasa de Interés Compuesto', child: Text('Tasa de Interés Compuesto')),
              DropdownMenuItem(value: 'Tiempo Simple', child: Text('Tiempo Simple')),
              DropdownMenuItem(value: 'Tiempo Compuesto', child: Text('Tiempo Compuesto')),
            ],
            onChanged: (v) {
              setState(() {
                calcular = v ?? 'Monto Futuro Simple';
                _cargarEjemplo(calcular);
                _cargarTeoriaYFormula(calcular);
                capitalCtrl.clear();
                tasaCtrl.clear();
                periodosCtrl.clear();
                montoCtrl.clear();
                resultado = '';
              });
            },
            decoration: const InputDecoration(labelText: 'Tipo de cálculo'),
          ),
          const SizedBox(height: 20),

          _buildCampos(),

          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _calcular,
            icon: const Icon(Icons.calculate),
            label: Text("Calcular", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),

          const SizedBox(height: 20),
          if (resultado.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.cyan.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                resultado,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.cyan.shade900),
              ),
            ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.cyan.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.cyan.shade200),
            ),
            child: Text(
              teoriaYFormula,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.cyan.shade900,
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
              border: Border.all(color: Colors.cyan.shade200),
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