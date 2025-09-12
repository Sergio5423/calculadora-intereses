import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class AnnuityPage extends StatefulWidget {
  const AnnuityPage({super.key});

  @override
  State<AnnuityPage> createState() => _AnnuityPageState();
}

class _AnnuityPageState extends State<AnnuityPage> {
  final cuotaCtrl = TextEditingController(); // R
  final tasaCtrl = TextEditingController(); // i (%) por periodo
  final periodosCtrl = TextEditingController(); // n
  final vfCtrl = TextEditingController(); // VF
  final vpCtrl = TextEditingController(); // VP

  String calcular = 'Valor Futuro';
  String unidad = 'años';
  String resultado = '';
  String ejemplo = '';
  String computeFrom = 'Desde VF';

  @override
  void initState() {
    super.initState();
    _cargarEjemplo(calcular);
  }

  void _cargarEjemplo(String tipo) {
    switch (tipo) {
      case 'Valor Futuro':
        ejemplo =
            'Ejemplo: Una anualidad de \$500,000 COP trimestral al 3% durante 8 periodos:\n'
            'VF = 500,000 * [ (1+0.03)^8 - 1 ] / 0.03\n'
            'Resultado ≈ \$4,446,200 COP.';
        break;
      case 'Valor Presente':
        ejemplo =
            'Ejemplo: Una anualidad de \$500,000 COP trimestral al 3% durante 8 periodos:\n'
            'VP = 500,000 * [ 1 - (1+0.03)^-8 ] / 0.03\n'
            'Resultado ≈ \$3,509,850 COP.';
        break;
      case 'Cuota periódica (R)':
        ejemplo = 'Ejemplo con VF: Si VF=4,446,200 COP, i=3% y n=8:\n'
            'R = VF * i / [ (1+i)^n - 1 ]\n'
            'Resultado ≈ \$500,000 COP.\n\n'
            'Ejemplo con VP: Si VP=3,509,850 COP, i=3% y n=8:\n'
            'R = VP * i / [ 1 - (1+i)^-n ]\n'
            'Resultado ≈ \$500,000 COP.';
        break;
      case 'Número de periodos (n)':
        ejemplo = 'Ejemplo con VF: Si R=500,000 COP, VF=4,446,168 COP, i=3%:\n'
            'n = ln(1 + (VF*i)/R) / ln(1+i)\n'
            'Resultado ≈ 8 periodos.\n\n'
            'Ejemplo con VP: Si R=500,000 COP, VP=3,509,850 COP, i=3%:\n'
            'n = ln(R / (R - VP*i)) / ln(1+i)\n'
            'Resultado ≈ 8 periodos.';
        break;
      default:
        ejemplo = '';
    }
    setState(() {});
  }

  void _limpiarCampos({bool keepExample = true}) {
    cuotaCtrl.clear();
    tasaCtrl.clear();
    periodosCtrl.clear();
    vfCtrl.clear();
    vpCtrl.clear();
    resultado = '';
    if (!keepExample) ejemplo = '';
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _calcular() {
    final R = double.tryParse(cuotaCtrl.text.replaceAll(',', '.')) ?? 0.0;
    final iPct = double.tryParse(tasaCtrl.text.replaceAll(',', '.')) ?? 0.0;
    final n = double.tryParse(periodosCtrl.text.replaceAll(',', '.')) ?? 0.0;
    final VF = double.tryParse(vfCtrl.text.replaceAll(',', '.')) ?? 0.0;
    final VP = double.tryParse(vpCtrl.text.replaceAll(',', '.')) ?? 0.0;

    final i = iPct / 100;

    try {
      switch (calcular) {
        case 'Valor Futuro':
          if (i == 0) {
            final vf = R * n;
            resultado = 'Valor Futuro (VF): \$${vf.toStringAsFixed(2)} COP';
          } else {
            final vf = R * ((pow(1 + i, n) - 1) / i);
            resultado =
                'Valor Futuro (VF): \$${vf.toStringAsFixed(2)} COP\nInterés total ≈ \$${(vf - R * n).toStringAsFixed(2)} COP';
          }
          break;

        case 'Valor Presente':
          if (i == 0) {
            final vp = R * n;
            resultado = 'Valor Presente (VP): \$${vp.toStringAsFixed(2)} COP';
          } else {
            final vp = R * ((1 - pow(1 + i, -n)) / i);
            resultado = 'Valor Presente (VP): \$${vp.toStringAsFixed(2)} COP';
          }
          break;

        case 'Cuota periódica (R)':
          if (computeFrom == 'Desde VF') {
            final r = VF * i / (pow(1 + i, n) - 1);
            resultado = 'Cuota periódica (R): \$${r.toStringAsFixed(2)} COP';
          } else {
            final r = VP * i / (1 - pow(1 + i, -n));
            resultado = 'Cuota periódica (R): \$${r.toStringAsFixed(2)} COP';
          }
          break;

        case 'Número de periodos (n)':
          double nn;
          if (computeFrom == 'Desde VF') {
            nn = log(1 + VF * i / R) / log(1 + i);
          } else {
            nn = log(R / (R - VP * i)) / log(1 + i);
          }
          resultado = 'Número de periodos (n): ${nn.toStringAsFixed(2)}';
          break;
      }

      setState(() {});
    } catch (e) {
      _showError('Error en el cálculo: $e');
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
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anualidad Ordinaria',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Calculadora de Anualidades',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800)), // ✅ Verde
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: calcular,
            items: const [
              DropdownMenuItem(
                  value: 'Valor Futuro', child: Text('Calcular Valor Futuro')),
              DropdownMenuItem(
                  value: 'Valor Presente',
                  child: Text('Calcular Valor Presente')),
              DropdownMenuItem(
                  value: 'Cuota periódica (R)',
                  child: Text('Despejar cuota periódica (R)')),
              DropdownMenuItem(
                  value: 'Número de periodos (n)',
                  child: Text('Despejar número de periodos (n)')),
            ],
            onChanged: (v) {
              setState(() {
                calcular = v ?? 'Valor Futuro';
                _limpiarCampos();
                _cargarEjemplo(calcular);
                if (calcular == 'Cuota periódica (R)' ||
                    calcular == 'Número de periodos (n)') {
                  computeFrom = 'Desde VF';
                }
              });
            },
            decoration:
                const InputDecoration(labelText: '¿Qué deseas calcular?'),
          ),
          const SizedBox(height: 20),

          if (calcular == 'Valor Futuro' || calcular == 'Valor Presente') ...[
            _input(cuotaCtrl, 'Cuota periódica (R)', hint: 'Ej: 500000'),
            const SizedBox(height: 12),
            _input(tasaCtrl, 'Tasa i (%) por periodo', hint: 'Ej: 3'),
            const SizedBox(height: 12),
            _input(periodosCtrl, 'Número de periodos (n)', hint: 'Ej: 8'),
          ],

          if (calcular == 'Cuota periódica (R)' ||
              calcular == 'Número de periodos (n)') ...[
            DropdownButtonFormField<String>(
              value: computeFrom,
              items: const [
                DropdownMenuItem(
                    value: 'Desde VF', child: Text('Desde VF (Valor Futuro)')),
                DropdownMenuItem(
                    value: 'Desde VP',
                    child: Text('Desde VP (Valor Presente)')),
              ],
              onChanged: (v) {
                setState(() {
                  computeFrom = v ?? 'Desde VF';
                  _limpiarCampos();
                });
              },
              decoration:
                  const InputDecoration(labelText: 'Conocer a partir de'),
            ),
            const SizedBox(height: 12),
            if (computeFrom == 'Desde VF')
              _input(vfCtrl, 'Valor Futuro (VF)', hint: 'Ej: 4446200'),
            if (computeFrom == 'Desde VP')
              _input(vpCtrl, 'Valor Presente (VP)', hint: 'Ej: 3509850'),
            const SizedBox(height: 12),
            if (calcular == 'Cuota periódica (R)')
              _input(periodosCtrl, 'Número de periodos (n)', hint: 'Ej: 8'),
            if (calcular == 'Número de periodos (n)')
              _input(cuotaCtrl, 'Cuota periódica (R)', hint: 'Ej: 500000'),
            const SizedBox(height: 12),
            _input(tasaCtrl, 'Tasa i (%) por periodo', hint: 'Ej: 3'),
          ],

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
                color: Colors.green.shade50, // ✅ Verde
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                resultado,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900), // ✅ Verde
              ),
            ),

          const SizedBox(height: 16),
          if (ejemplo.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200), // ✅ Verde
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
