import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class TirPage extends StatefulWidget {
  const TirPage({super.key});

  @override
  State<TirPage> createState() => _TirPageState();
}

class _TirPageState extends State<TirPage> {
  final inversionInicialCtrl =
      TextEditingController(); // C0 - Inversión inicial
  final flujosCtrl = TextEditingController(); // Para todos los flujos variables
  final tasaMinimaCtrl = TextEditingController(); // Tasa mínima aceptable

  String calcular = 'TIR Series Variables';
  String resultado = '';
  String ejemplo = '';
  String teoriaYFormula = '';
  List<double> flujos = [];

  @override
  void initState() {
    super.initState();
    _cargarEjemplo(calcular);
    _cargarTeoriaYFormula(calcular);
  }

  void _cargarEjemplo(String tipo) {
    switch (tipo) {
      case 'TIR Series Variables':
        ejemplo = 'Ejemplo: Inversión inicial: -\$5,000\n'
            'Flujos: 2000, 2000, 2000\n'
            'TIR ≈ 9.7010%\n\n'
            'Ejemplo 2: Inversión: -\$10,000\n'
            'Flujos: 3000, 4000, 5000, 3000\n'
            'TIR ≈ 18.0282%';
        break;
      case 'VAN con TIR':
        ejemplo = 'Ejemplo: Inversión: -\$5,000, Flujos: 2000, 2000, 2000\n'
            'TIR=9.70% → Si tasa mínima=8% → VAN positivo\n'
            'Si tasa mínima=12% → VAN negativo';
        break;
    }
  }

  void _cargarTeoriaYFormula(String tipo) {
    switch (tipo) {
      case 'TIR Series Variables':
      case 'VAN con TIR':
        teoriaYFormula = "TASA INTERNA DE RETORNO (TIR)\n\n"
            "DEFINICIÓN:\n"
            "• Tasa que hace el VAN igual a cero\n"
            "• Mide la rentabilidad de una inversión\n"
            "• Criterio de aceptación: TIR > tasa mínima\n\n"
            "FÓRMULA TIR:\n"
            "0 = C₀ + Σ [Fₜ / (1 + TIR)ᵗ]\n\n"
            "Donde:\n"
            "• C₀ = Inversión inicial (negativa)\n"
            "• Fₜ = Flujo en el período t\n"
            "• TIR = Tasa Interna de Retorno\n"
            "• t = Período de tiempo\n\n"
            "VALOR ACTUAL NETO (VAN):\n"
            "VAN = C₀ + Σ [Fₜ / (1 + i)ᵗ]";
        break;
    }
  }

  void _procesarFlujos() {
    final texto = flujosCtrl.text;
    if (texto.isEmpty) return;

    final valores = texto.split(RegExp(r'[,\s]+'));
    flujos.clear();

    for (var valor in valores) {
      final num = double.tryParse(valor.trim());
      if (num != null) {
        flujos.add(num);
      }
    }

    setState(() {});
  }

  double _calcularVAN(List<double> flujos, double tasa) {
    double van = flujos[0]; // Inversión inicial (negativa)
    for (int t = 1; t < flujos.length; t++) {
      van += flujos[t] / pow(1 + tasa, t);
    }
    return van;
  }

  double _calcularTIR(List<double> flujos,
      {double tol = 1e-6, int maxIter = 100}) {
    double tirInferior = -0.99;
    double tirSuperior = 10.0;

    double vanInferior = _calcularVAN(flujos, tirInferior);
    double vanSuperior = _calcularVAN(flujos, tirSuperior);

    // Validar cambio de signo
    if (vanInferior * vanSuperior > 0) {
      throw Exception('No se puede calcular TIR: VAN no cambia de signo\n'
          'Verifique que:\n'
          '• La inversión inicial sea negativa\n'
          '• Haya flujos positivos posteriores\n'
          '• Los flujos permitan recuperación');
    }

    double tir = 0.0;
    for (int i = 0; i < maxIter; i++) {
      tir = (tirInferior + tirSuperior) / 2;
      double van = _calcularVAN(flujos, tir);

      if (van.abs() < tol) break;

      if (vanInferior * van < 0) {
        tirSuperior = tir;
        vanSuperior = van;
      } else {
        tirInferior = tir;
        vanInferior = van;
      }
    }

    return tir;
  }

  void _calcular() {
    final C0 = double.tryParse(inversionInicialCtrl.text) ?? 0.0;
    final tasaMinima = double.tryParse(tasaMinimaCtrl.text) ?? 0.0;

    try {
      // Procesar flujos del campo de texto
      _procesarFlujos();

      // Construir array completo de flujos
      List<double> flujosCompletos = [];
      // Normalizar inversión inicial: siempre negativa
      flujosCompletos.add(C0 > 0 ? -C0 : C0);
      flujosCompletos.addAll(flujos);

      if (flujosCompletos.length < 2) {
        throw Exception('Ingrese al menos un flujo futuro');
      }

      final tir = _calcularTIR(flujosCompletos);

      if (calcular == 'VAN con TIR') {
        final van = _calcularVAN(flujosCompletos, tasaMinima / 100);

        resultado = 'TIR del proyecto: ${(tir * 100).toStringAsFixed(4)}%\n'
            'VAN con tasa ${tasaMinima.toStringAsFixed(2)}%: \$${van.toStringAsFixed(2)}\n\n'
            'ANÁLISIS:\n';

        if (tir > tasaMinima / 100) {
          resultado += '✓ TIR > tasa mínima → PROYECTO VIABLE\n';
          resultado += '✓ VAN positivo → CREA VALOR';
        } else if (tir < tasaMinima / 100) {
          resultado += '✗ TIR < tasa mínima → PROYECTO NO VIABLE\n';
          resultado += '✗ VAN negativo → DESTRUYE VALOR';
        } else {
          resultado += '═ TIR = tasa mínima → PUNTO DE EQUILIBRIO\n';
          resultado += '═ VAN cero → NO CREA VALOR';
        }
      } else {
        final vanCero = _calcularVAN(flujosCompletos, tir); // debería ser ≈ 0

        resultado =
            'TASA INTERNA DE RETORNO (TIR): ${(tir * 100).toStringAsFixed(4)}%\n\n'
            'FLUJOS DE CAJA:\n'
            'Año 0: -\$${(C0 > 0 ? C0 : -C0).toStringAsFixed(2)}\n';

        for (int i = 0; i < flujos.length; i++) {
          resultado += 'Año ${i + 1}: \$${flujos[i].toStringAsFixed(2)}\n';
        }

        resultado += '\nVERIFICACIÓN:\n'
            'VAN con TIR: \$${vanCero.toStringAsFixed(4)} (≈ 0)';
      }

      setState(() {});
    } catch (e) {
      setState(() {
        resultado = 'Error en el cálculo: $e\n\n'
            'Asegúrese de:\n'
            '• Ingresar inversión inicial positiva\n'
            '• Ingresar flujos futuros separados por comas\n'
            '• Los flujos permitan recuperar la inversión\n'
            '• Ejemplo: 2000, 2000, 2000';
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
      case 'TIR Series Variables':
        return Column(
          children: [
            _input(inversionInicialCtrl, 'Inversión inicial (C0)',
                hint: 'Ej: 5000'),
            const SizedBox(height: 12),
            TextField(
              controller: flujosCtrl,
              decoration: InputDecoration(
                labelText: 'Flujos futuros (separados por comas)',
                hintText: 'Ej: 2000, 2000, 2000',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _procesarFlujos,
                ),
              ),
              onChanged: (value) => _procesarFlujos(),
            ),
            if (flujos.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Flujos procesados (${flujos.length} años): ${flujos.map((v) => v.toStringAsFixed(0)).join(', ')}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ],
        );

      case 'VAN con TIR':
        return Column(
          children: [
            _input(inversionInicialCtrl, 'Inversión inicial (C0)',
                hint: 'Ej: 5000'),
            const SizedBox(height: 12),
            TextField(
              controller: flujosCtrl,
              decoration: InputDecoration(
                labelText: 'Flujos futuros (separados por comas)',
                hintText: 'Ej: 2000, 2000, 2000',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _procesarFlujos,
                ),
              ),
              onChanged: (value) => _procesarFlujos(),
            ),
            if (flujos.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Flujos procesados (${flujos.length} años): ${flujos.map((v) => v.toStringAsFixed(0)).join(', ')}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.green.shade700,
                ),
              ),
            ],
            const SizedBox(height: 12),
            _input(tasaMinimaCtrl, 'Tasa mínima aceptable (%)', hint: 'Ej: 8'),
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
        title: Text('Tasa Interna de Retorno (TIR)',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Calculadora de TIR y VAN',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: calcular,
            items: const [
              DropdownMenuItem(
                  value: 'TIR Series Variables',
                  child: Text('TIR - Tasa Interna de Retorno')),
              DropdownMenuItem(
                  value: 'VAN con TIR', child: Text('VAN con TIR')),
            ],
            onChanged: (v) {
              setState(() {
                calcular = v ?? 'TIR Series Variables';
                _cargarEjemplo(calcular);
                _cargarTeoriaYFormula(calcular);
                inversionInicialCtrl.clear();
                flujosCtrl.clear();
                tasaMinimaCtrl.clear();
                flujos.clear();
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
            label: Text("Calcular",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 20),
          if (resultado.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                resultado,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade900),
              ),
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              teoriaYFormula,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.red.shade900,
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
              border: Border.all(color: Colors.red.shade200),
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
