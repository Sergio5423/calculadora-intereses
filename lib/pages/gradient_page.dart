import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class GradientPage extends StatefulWidget {
  const GradientPage({super.key});

  @override
  State<GradientPage> createState() => _GradientPageState();
}

class _GradientPageState extends State<GradientPage> {
  final rCtrl = TextEditingController(); // R - Pago inicial
  final tasaCtrl = TextEditingController(); // i - Tasa
  final periodosCtrl = TextEditingController(); // n - Periodos
  final gCtrl = TextEditingController(); // G - Gradiente aritmético
  final gPorcCtrl = TextEditingController(); // g% - Gradiente geométrico
  final valoresCtrl = TextEditingController(); // Para series variables

  String calcular = 'Valor Presente Aritmético';
  String resultado = '';
  String ejemplo = '';
  Widget teoriaYFormulaWidget = const SizedBox();
  List<double> valoresSeries = [];
  List<Map<String, dynamic>> detalleCalculos = [];

  @override
  void initState() {
    super.initState();
    _cargarEjemplo(calcular);
    _cargarTeoriaYFormula(calcular);
  }

  void _cargarEjemplo(String tipo) {
    switch (tipo) {
      case 'Valor Presente Aritmético':
        ejemplo =
            'Ejemplo: Pagos que empiezan en \$1,000 y aumentan \$200 cada año,\n'
            'durante 5 años con tasa 10% anual.\n'
            'VA ≈ \$5,163.15';
        break;
      case 'Valor Presente Geométrico':
        ejemplo = 'Ejemplo: Pagos que empiezan en \$1,000 y crecen 5% anual,\n'
            'durante 5 años con tasa 10% anual.\n'
            'VA ≈ \$4,150.59';
        break;
      case 'Valor Futuro Aritmético':
        ejemplo =
            'Ejemplo: Pagos que empiezan en \$1,000 y aumentan \$200 cada año,\n'
            'durante 5 años con tasa 10% anual.\n'
            'VF ≈ \$8,315.30';
        break;
      case 'Valor Futuro Geométrico':
        ejemplo = 'Ejemplo: Pagos que empiezan en \$1,000 y crecen 5% anual,\n'
            'durante 5 años con tasa 10% anual.\n'
            'VF ≈ \$6,684.57';
        break;
      case 'Series Variables - Valor Presente':
        ejemplo = 'Ejemplo: Pagos: [1000, 1200, 1500, 1300, 2000]\n'
            'con tasa 10% anual.\n'
            'VA ≈ \$5,263.98';
        break;
      case 'Series Variables - Valor Futuro':
        ejemplo = 'Ejemplo: Pagos: [1000, 1200, 1500, 1300, 2000]\n'
            'con tasa 10% anual.\n'
            'VF ≈ \$8,478.11';
        break;
    }
  }

  void _cargarTeoriaYFormula(String tipo) {
    String teoria = '';
    String? formulaImageAsset;

    switch (tipo) {
      case 'Valor Presente Aritmético':
        teoria = "TEORÍA DE GRADIENTES ARITMÉTICOS\n\n"
            "DEFINICIÓN:\n"
            "• Serie de pagos que aumentan/disminuyen en cantidad fija\n"
            "• Cambio constante (G) en cada período\n"
            "• Aplicable a flujos con crecimiento lineal\n\n"
            "Donde:\n"
            "• VA = Valor Presente\n"
            "• R = Pago inicial\n"
            "• i = Tasa de interés\n"
            "• n = Número de períodos\n"
            "• G = Incremento fijo por período";
        formulaImageAsset = 'assets/grad_arit_va.png';
        break;

      case 'Valor Presente Geométrico':
        teoria = "TEORÍA DE GRADIENTES GEOMÉTRICOS\n\n"
            "DEFINICIÓN:\n"
            "• Serie de pagos que crecen en porcentaje fijo\n"
            "• Cambio porcentual (g%) en cada período\n"
            "• Aplicable a flujos con crecimiento exponencial\n\n"
            "Donde:\n"
            "• VA = Valor Presente\n"
            "• R = Pago inicial\n"
            "• i = Tasa de interés\n"
            "• n = Número de períodos\n"
            "• g = Tasa de crecimiento porcentual";
        formulaImageAsset = 'assets/grad_geo_va.png';
        break;

      case 'Valor Futuro Aritmético':
        teoria = "TEORÍA DE GRADIENTES ARITMÉTICOS\n\n"
            "CARACTERÍSTICAS:\n"
            "• Crecimiento lineal de los pagos\n"
            "• Incremento constante G\n"
            "• Útil para planificación financiera\n\n"
            "Donde:\n"
            "• VF = Valor Futuro\n"
            "• R = Pago inicial\n"
            "• i = Tasa de interés\n"
            "• n = Número de períodos\n"
            "• G = Incremento fijo por período";
        formulaImageAsset = 'assets/grad_arit_vf.png';
        break;

      case 'Valor Futuro Geométrico':
        teoria = "TEORÍA DE GRADIENTES GEOMÉTRICOS\n\n"
            "CARACTERÍSTICAS:\n"
            "• Crecimiento exponencial de pagos\n"
            "• Incremento porcentual g%\n"
            "• Modela inflación o crecimiento económico\n\n"
            "Donde:\n"
            "• VF = Valor Futuro\n"
            "• R = Pago inicial\n"
            "• i = Tasa de interés\n"
            "• n = Número de períodos\n"
            "• g = Tasa de crecimiento porcentual";
        setState(() {
          teoriaYFormulaWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                teoria,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.pink.shade900,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              _buildFormulaImage(
                  'assets/grad_geo_vf.png', 'FÓRMULA (CASO GENERAL i ≠ g):'),
              const SizedBox(height: 12),
              _buildFormulaImage(
                  'assets/grad_geo_vf2.png', 'FÓRMULA (CASO ESPECIAL i = g):'),
            ],
          );
        });
        return;

      case 'Series Variables - Valor Presente':
        teoria = "SERIES VARIABLES - VALOR PRESENTE\n\n"
            "DEFINICIÓN:\n"
            "• Serie de pagos con valores diferentes en cada período\n"
            "• No sigue un patrón específico de crecimiento\n"
            "• Útil para flujos de caja irregulares\n\n"
            "FÓRMULA:\n"
            "VA = Σ [Ft / (1 + i)^t]\n\n"
            "Donde:\n"
            "• VA = Valor Presente\n"
            "• Ft = Flujo en el período t\n"
            "• i = Tasa de interés\n"
            "• t = Período (desde 1 hasta n)";
        break;

      case 'Series Variables - Valor Futuro':
        teoria = "SERIES VARIABLES - VALOR FUTURO\n\n"
            "DEFINICIÓN:\n"
            "• Serie de pagos con valores diferentes en cada período\n"
            "• No sigue un patrón específico de crecimiento\n"
            "• Útil para flujos de caja irregulares\n\n"
            "FÓRMULA:\n"
            "VF = Σ [Ft × (1 + i)^(n-t)]\n\n"
            "Donde:\n"
            "• VF = Valor Futuro\n"
            "• Ft = Flujo en el período t\n"
            "• i = Tasa de interés\n"
            "• n = Número total de períodos\n"
            "• t = Período actual";
        break;
    }

    _buildSingleFormulaWidget(teoria, formulaImageAsset);
  }

  void _buildSingleFormulaWidget(String teoria, String? formulaImageAsset) {
    setState(() {
      teoriaYFormulaWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            teoria,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.pink.shade900,
              height: 1.4,
            ),
          ),
          if (formulaImageAsset != null) ...[
            const SizedBox(height: 12),
            Text(
              "FÓRMULA:",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.pink.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.pink.shade100)),
              child: Image.asset(
                formulaImageAsset,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      'Error al cargar la imagen de la fórmula.\n'
                      'Asegúrate de que el archivo:\n"$formulaImageAsset"\n'
                      'exista y esté declarado en pubspec.yaml.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.red.shade800,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildFormulaImage(String imagePath, [String? title]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade900,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.pink.shade100)),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  void _procesarSeriesVariables() {
    final texto = valoresCtrl.text;
    if (texto.isEmpty) return;

    final valores = texto.split(RegExp(r'[,\s]+'));
    valoresSeries.clear();

    for (var valor in valores) {
      final num = double.tryParse(valor.trim());
      if (num != null) {
        valoresSeries.add(num);
      }
    }

    setState(() {});
  }

  Widget _buildTablaDetalle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DETALLE POR AÑO:',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              columns: [
                DataColumn(
                  label: Text('Año',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800)),
                ),
                DataColumn(
                  label: Text('Flujo',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800)),
                ),
                DataColumn(
                  label: Text(
                    calcular.contains('Presente')
                        ? 'Factor Desc.'
                        : 'Factor Cap.',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800),
                  ),
                ),
                DataColumn(
                  label: Text(
                    calcular.contains('Presente')
                        ? 'Valor Presente'
                        : 'Valor Futuro',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800),
                  ),
                ),
              ],
              rows: detalleCalculos.map((calculo) {
                return DataRow(cells: [
                  DataCell(Text('${calculo['año']}')),
                  DataCell(Text('\$${calculo['flujo'].toStringAsFixed(2)}')),
                  DataCell(Text(calculo['factor'].toStringAsFixed(4))),
                  DataCell(Text(
                    '\$${calculo['valor'].toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  )),
                ]);
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                Text(
                  '\$${detalleCalculos.fold(0.0, (sum, item) => sum + item['valor']).toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _calcular() {
    final R = double.tryParse(rCtrl.text) ?? 0.0;
    final iPct = double.tryParse(tasaCtrl.text) ?? 0.0;
    final n = double.tryParse(periodosCtrl.text) ?? 0.0;
    final G = double.tryParse(gCtrl.text) ?? 0.0;
    final gPct = double.tryParse(gPorcCtrl.text) ?? 0.0;

    final i = iPct / 100;
    final g = gPct / 100;

    detalleCalculos.clear();

    try {
      switch (calcular) {
        case 'Valor Presente Aritmético':
          if (i == 0) {
            final va = R * n + G * n * (n - 1) / 2;
            resultado = 'Valor Presente (VA): \$${va.toStringAsFixed(2)}';
          } else {
            final vPowN = pow(1 + i, -n);
            final a = (1 - vPowN) / i;
            final term1 = R * a;
            final term2 = G * ((a - n * vPowN) / i);
            final va = term1 + term2;
            resultado = 'Valor Presente (VA): \$${va.toStringAsFixed(2)}';
          }
          break;

        case 'Valor Presente Geométrico':
          final eps = 1e-12;
          if ((i - g).abs() < eps) {
            final va = R * n / (1 + i);
            resultado = 'Valor Presente (VA): \$${va.toStringAsFixed(2)}';
          } else {
            final ratio = (1 + g) / (1 + i);
            final va = R * (1 - pow(ratio, n)) / (i - g);
            resultado = 'Valor Presente (VA): \$${va.toStringAsFixed(2)}';
          }
          break;

        case 'Valor Futuro Aritmético':
          if (i == 0) {
            final vf = R * n + G * n * (n - 1) / 2;
            resultado = 'Valor Futuro (VF): \$${vf.toStringAsFixed(2)}';
          } else {
            final term1 = R * ((pow(1 + i, n) - 1) / i);
            final term2 = G * (((pow(1 + i, n) - 1) / i - n) / i);
            final vf = term1 + term2;
            resultado = 'Valor Futuro (VF): \$${vf.toStringAsFixed(2)}';
          }
          break;

        case 'Valor Futuro Geométrico':
          if (i == g) {
            final vf = R * n * pow(1 + i, n - 1);
            resultado = 'Valor Futuro (VF): \$${vf.toStringAsFixed(2)}';
          } else {
            final factor_interno = (1 - pow((1 + g) / (1 + i), n)) / (i - g);
            final vf = R * factor_interno * pow(1 + i, n);
            resultado = 'Valor Futuro (VF): \$${vf.toStringAsFixed(2)}';
          }
          break;

        case 'Series Variables - Valor Presente':
          _procesarSeriesVariables();
          if (valoresSeries.isEmpty) {
            resultado = 'Error: Ingrese valores para las series variables';
          } else {
            double va = 0.0;
            for (int t = 0; t < valoresSeries.length; t++) {
              final flujo = valoresSeries[t];
              final factor = pow(1 + i, -(t + 1));
              final valorPresente = flujo * factor;
              va += valorPresente;

              detalleCalculos.add({
                'año': t + 1,
                'flujo': flujo,
                'factor': factor,
                'valor': valorPresente,
              });
            }
            resultado = 'Valor Presente (VA): \$${va.toStringAsFixed(2)}\n'
                'Número de flujos: ${valoresSeries.length}';
          }
          break;

        case 'Series Variables - Valor Futuro':
          _procesarSeriesVariables();
          if (valoresSeries.isEmpty) {
            resultado = 'Error: Ingrese valores para las series variables';
          } else {
            double vf = 0.0;
            final n = valoresSeries.length;
            for (int t = 0; t < n; t++) {
              final flujo = valoresSeries[t];
              final factor = pow(1 + i, n - t - 1);
              final valorFuturo = flujo * factor;
              vf += valorFuturo;

              detalleCalculos.add({
                'año': t + 1,
                'flujo': flujo,
                'factor': factor,
                'valor': valorFuturo,
              });
            }
            resultado = 'Valor Futuro (VF): \$${vf.toStringAsFixed(2)}\n'
                'Número de flujos: ${valoresSeries.length}';
          }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gradientes y Series Variables',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Calculadora de Gradientes y Series Variables',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade800)),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: calcular,
            items: const [
              DropdownMenuItem(
                  value: 'Valor Presente Aritmético',
                  child: Text('Valor Presente Aritmético')),
              DropdownMenuItem(
                  value: 'Valor Presente Geométrico',
                  child: Text('Valor Presente Geométrico')),
              DropdownMenuItem(
                  value: 'Valor Futuro Aritmético',
                  child: Text('Valor Futuro Aritmético')),
              DropdownMenuItem(
                  value: 'Valor Futuro Geométrico',
                  child: Text('Valor Futuro Geométrico')),
              DropdownMenuItem(
                  value: 'Series Variables - Valor Presente',
                  child: Text('Series Variables - Valor Presente')),
              DropdownMenuItem(
                  value: 'Series Variables - Valor Futuro',
                  child: Text('Series Variables - Valor Futuro')),
            ],
            onChanged: (v) {
              setState(() {
                calcular = v ?? 'Valor Presente Aritmético';
                _cargarEjemplo(calcular);
                _cargarTeoriaYFormula(calcular);
                rCtrl.clear();
                tasaCtrl.clear();
                periodosCtrl.clear();
                gCtrl.clear();
                gPorcCtrl.clear();
                valoresCtrl.clear();
                valoresSeries.clear();
                detalleCalculos.clear();
                resultado = '';
              });
            },
            decoration: const InputDecoration(labelText: 'Tipo de cálculo'),
          ),
          const SizedBox(height: 20),

          // Campos comunes para gradientes
          if (calcular.contains('Aritmético') ||
              calcular.contains('Geométrico')) ...[
            _input(rCtrl, 'Pago inicial (R)', hint: 'Ej: 1000'),
            const SizedBox(height: 12),
            _input(tasaCtrl, 'Tasa i (%) por periodo', hint: 'Ej: 10'),
            const SizedBox(height: 12),
            _input(periodosCtrl, 'Número de periodos (n)', hint: 'Ej: 5'),
          ],

          // Campos específicos para gradientes aritméticos
          if (calcular == 'Valor Presente Aritmético' ||
              calcular == 'Valor Futuro Aritmético') ...[
            const SizedBox(height: 12),
            _input(gCtrl, 'Gradiente aritmético (G)', hint: 'Ej: 200'),
          ],

          // Campos específicos para gradientes geométricos
          if (calcular == 'Valor Presente Geométrico' ||
              calcular == 'Valor Futuro Geométrico') ...[
            const SizedBox(height: 12),
            _input(gPorcCtrl, 'Gradiente geométrico (g%)', hint: 'Ej: 5'),
          ],

          // Campos para series variables
          if (calcular.contains('Series Variables')) ...[
            _input(tasaCtrl, 'Tasa i (%) por periodo', hint: 'Ej: 10'),
            const SizedBox(height: 12),
            TextField(
              controller: valoresCtrl,
              decoration: InputDecoration(
                labelText: 'Valores de los flujos',
                hintText: 'Ej: 1000, 1200, 1500, 1300, 2000',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _procesarSeriesVariables,
                ),
              ),
              onChanged: (value) => _procesarSeriesVariables(),
            ),
            if (valoresSeries.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Flujos procesados (${valoresSeries.length}): ${valoresSeries.map((v) => v.toStringAsFixed(0)).join(', ')}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.green.shade700,
                ),
              ),
            ],
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
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resultado,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade900),
                  ),
                  if (detalleCalculos.isNotEmpty) _buildTablaDetalle(),
                ],
              ),
            ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.pink.shade200),
            ),
            child: teoriaYFormulaWidget,
          ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.pink.shade200),
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
