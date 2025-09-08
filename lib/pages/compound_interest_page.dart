import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class CompoundInterestPage extends StatefulWidget {
  const CompoundInterestPage({super.key});

  @override
  State<CompoundInterestPage> createState() => _CompoundInterestPageState();
}

class _CompoundInterestPageState extends State<CompoundInterestPage> {
  final capitalCtrl = TextEditingController();
  final tasaCtrl = TextEditingController();
  final montoCtrl = TextEditingController();
  final periodosCtrl = TextEditingController();

  String calcular = 'Monto Futuro';
  String unidadTiempo = 'meses';
  String unidadTasa = 'mensual';
  String resultado = '';
  String ejemplo =
      'Ejemplo: Si inviertes \$1,000,000 COP al 2% mensual durante 12 meses,\n'
      'el monto futuro será de ≈ \$1,268,241 COP.'; // ejemplo por defecto

  void _limpiarCampos() {
    capitalCtrl.clear();
    tasaCtrl.clear();
    montoCtrl.clear();
    periodosCtrl.clear();
    resultado = '';
    // El ejemplo no se borra, se mantiene por defecto
  }

  /// Convierte la tasa ingresada a la misma unidad de tiempo que `unidadTiempo`
  double _convertirTasa(double iPct, String unidadTasa, String unidadTiempo) {
    final i = iPct / 100; // convertir a decimal

    // convertir la tasa efectiva de entrada a anual
    double iAnual;
    switch (unidadTasa) {
      case 'mensual':
        iAnual = pow(1 + i, 12) - 1;
        break;
      case 'trimestral':
        iAnual = pow(1 + i, 4) - 1;
        break;
      case 'semestral':
        iAnual = pow(1 + i, 2) - 1;
        break;
      default: // anual
        iAnual = i;
    }

    // convertir la tasa anual a la unidad de tiempo seleccionada
    switch (unidadTiempo) {
      case 'meses':
        return pow(1 + iAnual, 1 / 12) - 1;
      case 'trimestres':
        return pow(1 + iAnual, 1 / 4) - 1;
      case 'semestres':
        return pow(1 + iAnual, 1 / 2) - 1;
      default: // años
        return iAnual;
    }
  }

  void _calcular() {
    final C = double.tryParse(capitalCtrl.text) ?? 0.0;
    final iPct = double.tryParse(tasaCtrl.text) ?? 0.0;
    final M = double.tryParse(montoCtrl.text) ?? 0.0;
    final n = double.tryParse(periodosCtrl.text) ?? 0.0;

    switch (calcular) {
      case 'Monto Futuro':
        if (C <= 0 || iPct <= 0 || n <= 0) {
          setState(() {
            resultado =
                "Por favor ingresa Capital, Tasa y Número de periodos válidos.";
          });
          return;
        }
        final i = _convertirTasa(iPct, unidadTasa, unidadTiempo);
        final MF = C * pow((1 + i), n);
        resultado =
            'Monto Futuro (M): \$${MF.toStringAsFixed(2)} COP\nInterés generado: \$${(MF - C).toStringAsFixed(2)} COP';
        ejemplo =
            'Ejemplo: Si inviertes \$1,000,000 COP al 2% mensual durante 12 meses,\n'
            'el monto futuro será de ≈ \$1,268,241 COP.';
        break;

      case 'Tasa de Interés':
        if (C <= 0 || M <= 0 || n <= 0) {
          setState(() {
            resultado =
                "Por favor ingresa Capital, Monto Futuro y Número de periodos válidos.";
          });
          return;
        }
        final tasa = (pow(M / C, 1 / n) - 1) * 100;
        resultado = 'Tasa de interés (i): ${tasa.toStringAsFixed(2)}%';
        ejemplo =
            'Ejemplo: Si el capital de \$1,000,000 COP se convierte en \$1,268,241 en 12 meses,\n'
            'la tasa aproximada es del 2% mensual.';
        break;

      case 'Tiempo':
        if (C <= 0 || iPct <= 0 || M <= 0) {
          setState(() {
            resultado =
                "Por favor ingresa Capital, Tasa y Monto Futuro válidos.";
          });
          return;
        }
        final i = _convertirTasa(iPct, unidadTasa, unidadTiempo);
        final tiempo = (log(M / C) / log(1 + i));
        resultado =
            'Tiempo necesario (n): ${tiempo.toStringAsFixed(2)} $unidadTiempo';
        ejemplo =
            'Ejemplo: Si inviertes \$1,000,000 COP al 2% mensual y deseas llegar a \$1,268,241 COP,\n'
            'necesitarás alrededor de 12 meses.';
        break;
      case 'Capital':
        final i = _convertirTasa(iPct, unidadTasa, unidadTiempo);
        final capital = M / pow((1 + i), n);
        resultado = 'Capital (C): ${capital.toStringAsFixed(2)} COP';
        ejemplo = ''
            '';
        break;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle =
        GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18);

    return Scaffold(
      appBar: AppBar(
        title: Text('Interés Compuesto',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Calculadora de Interés Compuesto',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800)),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: calcular,
            items: const [
              DropdownMenuItem(
                  value: 'Monto Futuro', child: Text('Calcular Monto Futuro')),
              DropdownMenuItem(
                  value: 'Tasa de Interés',
                  child: Text('Calcular Tasa de Interés')),
              DropdownMenuItem(value: 'Tiempo', child: Text('Calcular Tiempo')),
              DropdownMenuItem(
                  value: 'Capital', child: Text('Calcular Capital')),
            ],
            onChanged: (v) {
              setState(() {
                calcular = v ?? 'Monto Futuro';
                _limpiarCampos();
                // actualizar ejemplo según la opción seleccionada
                switch (calcular) {
                  case 'Monto Futuro':
                    ejemplo =
                        'Ejemplo: Si inviertes \$1,000,000 COP al 2% mensual durante 12 meses,\n'
                        'el monto futuro será de ≈ \$1,268,241 COP.';
                    break;
                  case 'Tasa de Interés':
                    ejemplo =
                        'Ejemplo: Si el capital de \$1,000,000 COP se convierte en \$1,268,241 en 12 meses,\n'
                        'la tasa aproximada es del 2% mensual.';
                    break;
                  case 'Tiempo':
                    ejemplo =
                        'Ejemplo: Si inviertes \$1,000,000 COP al 2% mensual y deseas llegar a \$1,268,241 COP,\n'
                        'necesitarás alrededor de 12 meses.';
                    break;
                }
              });
            },
            decoration:
                const InputDecoration(labelText: '¿Qué deseas calcular?'),
          ),
          const SizedBox(height: 20),

          // Campos dinámicos
          if (calcular == 'Monto Futuro' ||
              calcular == 'Tasa de Interés' ||
              calcular == 'Tiempo')
            _input(capitalCtrl, 'Capital (C)'),
          const SizedBox(height: 12),

          if (calcular == 'Monto Futuro' || calcular == 'Tiempo')
            _input(tasaCtrl, 'Tasa i (%)'),
          const SizedBox(height: 12),

          if (calcular == 'Tasa de Interés' || calcular == 'Tiempo')
            _input(montoCtrl, 'Monto Futuro (M)'),
          const SizedBox(height: 12),

          if (calcular == 'Capital') const SizedBox(height: 12),
          _input(montoCtrl, 'Monto Compuesto (MC)'),
          const SizedBox(height: 12),
          _input(tasaCtrl, 'Tasa i (%)'),
          const SizedBox(height: 12),
          if (calcular != 'Tiempo')
            Row(
              children: [
                Expanded(
                  child: _input(periodosCtrl, 'Número de periodos (n)'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: unidadTiempo,
                    items: const [
                      DropdownMenuItem(value: 'meses', child: Text('Meses')),
                      DropdownMenuItem(
                          value: 'trimestres', child: Text('Trimestres')),
                      DropdownMenuItem(
                          value: 'semestres', child: Text('Semestres')),
                      DropdownMenuItem(value: 'años', child: Text('Años')),
                    ],
                    onChanged: (v) =>
                        setState(() => unidadTiempo = v ?? 'meses'),
                    decoration:
                        const InputDecoration(labelText: 'Unidad de tiempo'),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 12),

          // Selector de unidad para la tasa
          DropdownButtonFormField<String>(
            value: unidadTasa,
            items: const [
              DropdownMenuItem(value: 'mensual', child: Text('Tasa mensual')),
              DropdownMenuItem(
                  value: 'trimestral', child: Text('Tasa trimestral')),
              DropdownMenuItem(
                  value: 'semestral', child: Text('Tasa semestral')),
              DropdownMenuItem(value: 'anual', child: Text('Tasa anual')),
            ],
            onChanged: (v) => setState(() => unidadTasa = v ?? 'mensual'),
            decoration: const InputDecoration(labelText: 'Unidad de la tasa'),
          ),

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

          const SizedBox(height: 16),
          if (ejemplo.isNotEmpty)
            Text(ejemplo, style: GoogleFonts.poppins(fontSize: 14)),
        ],
      ),
    );
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
}
