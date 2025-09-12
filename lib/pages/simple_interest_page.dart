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
    _cargarEjemplo(calcular);
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
      case 'TiempoInteres':
        ejemplo =
            'Ejemplo: Un capital de \$70,000 tardará en generar unos intereses de \$105,000\n'
            'a una tasa del 15% anual, unos 10 años.';
        break;
      case 'CapitalInteresTotal':
        ejemplo =
            'Ejemplo: Si necesitas pagar \$500 de interés, a una tasa del 5% y el préstamo\n'
            'dura 3 años entonces el monto del préstamo es de \$3,333.33 COP.';
        break;
      case 'CapitalInvertido':
        ejemplo =
            'Ejemplo: Para tener un monto final de \$4000 en 3 años a una tasa del 7%\n'
            'debes invertir \$3,305.79.';
        break;
      case 'Interés simple (básico)':
        ejemplo = 'Ejemplo: P = 6000, r = 4.8% anual, t = 2.5 años\n'
            'Interés = 6000 × 0.048 × 2.5 = 720\n'
            'Monto = 6000 + 720 = 6720\n'
            'Si retiras 3/4 → 5040.';
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
        final tiempo = interes / (C * i);
        resultado = 'Tiempo necesario (n): ${tiempo.toStringAsFixed(2)} Años';
        break;

      case 'CapitalInteresTotal':
        final capital = interes / (i * n);
        resultado = 'Monto del préstamo (C): ${capital.toStringAsFixed(2)} COP';
        break;

      case 'CapitalInvertido':
        final capital = M / (1 + i * n);
        resultado = 'Capital necesario (C): ${capital.toStringAsFixed(2)} COP';
        break;

      case 'Interés simple (básico)':
        if (C > 0 && i > 0 && n > 0) {
          final I = C * i * n;
          final MF = C + I;
          final retiro = MF * 0.75;
          resultado = 'Interés generado: \$${I.toStringAsFixed(2)}\n'
              'Monto acumulado: \$${MF.toStringAsFixed(2)}\n'
              'Retiro (3/4): \$${retiro.toStringAsFixed(2)}';
        }
        break;
    }
    setState(() {});
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
            _input(montoCtrl, 'Monto Futuro (M)'),
            const SizedBox(height: 12),
            _input(tasaCtrl, 'Tasa i (%) por periodo'),
            const SizedBox(height: 12),
            _input(periodosCtrl, 'Número de periodos (n)'),
          ],
        );
      case 'Interés simple (básico)':
        return Column(
          children: [
            _input(capitalCtrl, 'Capital (P)'),
            const SizedBox(height: 12),
            _input(tasaCtrl, 'Tasa de interés anual (j%)'),
            const SizedBox(height: 12),
            _input(periodosCtrl, 'Tiempo (años)'),
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
        FilteringTextInputFormatter.deny(RegExp(',')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  value: 'Tiempo',
                  child: Text('Calcular Tiempo (Monto Futuro)')),
              DropdownMenuItem(
                  value: 'TiempoInteres',
                  child: Text('Calcular Tiempo (Interes)')),
              DropdownMenuItem(
                  value: 'CapitalInteresTotal',
                  child: Text('Calcular Capital (Interés Total)')),
              DropdownMenuItem(
                  value: 'CapitalInvertido',
                  child: Text('Calcular Capital Invertido (Monto)')),
              DropdownMenuItem(
                  value: 'Interés simple (básico)',
                  child: Text('Cálculo básico de interés simple')),
            ],
            onChanged: (v) => setState(() {
              calcular = v ?? 'Monto Futuro';
              resultado = '';
              _cargarEjemplo(calcular);
              capitalCtrl.clear();
              tasaCtrl.clear();
              montoCtrl.clear();
              periodosCtrl.clear();
              interesCtrl.clear();
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
