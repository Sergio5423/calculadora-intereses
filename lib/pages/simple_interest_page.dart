import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

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
  final interesCtrl = TextEditingController();

  String calcular = 'Monto Futuro';
  String unidad = 'meses';
  String resultado = '';
  String ejemplo = '';

  @override
  void initState() {
    super.initState();
    _cargarEjemplo(calcular); // 👉 ejemplo por defecto al abrir la página
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

  void _calcular() {
    final C = double.tryParse(capitalCtrl.text) ?? 0.0;
    final iPct = double.tryParse(tasaCtrl.text) ?? 0.0;
    final M = double.tryParse(montoCtrl.text) ?? 0.0;
    final n = double.tryParse(periodosCtrl.text) ?? 0.0;
    final interes = double.tryParse(interesCtrl.text) ?? 0.0;

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
          resultado =
              'Tiempo necesario (n): ${tiempo.toStringAsFixed(2)} $unidad';
        }
        break;

      case 'TiempoInteres':
        //if (C > 0 && i > 0) {
        final tiempo = interes / (C * i);
        resultado = 'Tiempo necesario (n): ${tiempo.toStringAsFixed(2)} Años';
        //}
        break;

      case 'CapitalInteresTotal':
        //if (C > 0 && i > 0) {
        final capital = interes / (i * n);
        resultado = 'Capital necesario (C): ${capital.toStringAsFixed(2)} COP';
        //}
        break;
      case 'CapitalInvertido':
        //if (C > 0 && i > 0) {
        final capital = M / (1 + i * n);
        resultado = 'Capital necesario (C): ${capital.toStringAsFixed(2)} COP';
        //}
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
      case 'TiempoInteres':
        return Column(
          children: [
            _input(interesCtrl, 'Interes (I)'),
            const SizedBox(height: 12),
            _input(capitalCtrl, 'Capital (C)'),
            const SizedBox(height: 12),
            _input(tasaCtrl, 'Tasa i (%) por periodo'),
          ],
        );
      case 'CapitalInteresTotal':
        return Column(
          children: [
            _input(interesCtrl, 'Interes (I)'),
            const SizedBox(height: 12),
            _input(tasaCtrl, 'Tasa i (%) por periodo'),
            const SizedBox(height: 12),
            _input(periodosCtrl, 'Número de periodos (n)'),
          ],
        );
      case 'CapitalInvertido':
        return Column(
          children: [
            _input(montoCtrl, 'Capital (C)'),
            const SizedBox(height: 12),
            _input(tasaCtrl, 'Tasa i (%) por periodo'),
            const SizedBox(height: 12),
            _input(periodosCtrl, 'Número de periodos (n)'),
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
      inputFormatters: [
        // Bloquea las comas
        FilteringTextInputFormatter.deny(RegExp(',')),
      ],
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
              DropdownMenuItem(
                  value: 'Monto Futuro',
                  child: Text('Calcular Monto Futuro o Interés')),
              DropdownMenuItem(
                  value: 'Tasa de Interés',
                  child: Text('Calcular Tasa de Interés')),
              DropdownMenuItem(
                  value: 'Tiempo', child: Text('Calcular Tiempo (Capital)')),
              DropdownMenuItem(
                  value: 'TiempoInteres',
                  child: Text('Calcular Tiempo (Interes)')),
              DropdownMenuItem(
                  value: 'CapitalInteresTotal',
                  child: Text('Calcular Capital (Interes Total)')),
              DropdownMenuItem(
                  value: 'CapitalInvertido',
                  child: Text('Calcular Capital Invertido (Monto)')),
            ],
            onChanged: (v) => setState(() {
              calcular = v ?? 'Monto Futuro';
              resultado = '';
              _cargarEjemplo(
                  calcular); // 👉 actualiza el ejemplo automáticamente
              capitalCtrl.clear();
              tasaCtrl.clear();
              montoCtrl.clear();
              periodosCtrl.clear();
            }),
            decoration:
                const InputDecoration(labelText: '¿Qué deseas calcular?'),
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
