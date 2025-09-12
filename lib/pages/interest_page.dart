import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InterestPage extends StatefulWidget {
  const InterestPage({super.key});

  @override
  State<InterestPage> createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  final TextEditingController nominalController = TextEditingController(); // j
  final TextEditingController periodsController = TextEditingController(); // m
  final TextEditingController periodRateController =
      TextEditingController(); // i (%)

  String calcular = "Tasa Efectiva Anual (EA)";
  String resultado = "";
  String ejemplo = "";

  // Variables para tabla comparativa
  double? tasaI;
  double? tasaJ;
  double? tasaEA;

  @override
  void initState() {
    super.initState();
    _cargarEjemplo(calcular);
  }

  @override
  void dispose() {
    nominalController.dispose();
    periodsController.dispose();
    periodRateController.dispose();
    super.dispose();
  }

  void _cargarEjemplo(String tipo) {
    switch (tipo) {
      case "Tasa periódica (i)":
        ejemplo = "Ejemplo:\n"
            "j = 24% nominal, m = 12 (mensual)\n"
            "→ i = 2% por mes.\n"
            "Si inviertes \$1.000.000, en un mes se generan ≈ \$20.000 COP.";
        break;

      case "Tasa nominal anual (j)":
        ejemplo = "Ejemplo:\n"
            "i = 2% mensual, m = 12\n"
            "→ j = 24% nominal anual.\n"
            "Si cada mes ganas 2% sobre \$1.000.000, en 12 meses sumarías ≈ \$240.000 nominales.";
        break;

      case "Tasa Efectiva Anual (EA)":
        ejemplo = "Ejemplo:\n"
            "j = 24% nominal, m = 12 (mensual)\n"
            "→ EA ≈ 26.82%.\n"
            "Si inviertes \$1.000.000 durante un año, terminarías con ≈ \$1.268.241 COP.";
        break;
    }
    setState(() {});
  }

  void _calcular() {
    final j = double.tryParse(nominalController.text.replaceAll(',', '.')) ?? 0;
    final m = double.tryParse(periodsController.text.replaceAll(',', '.')) ?? 0;
    final iPct =
        double.tryParse(periodRateController.text.replaceAll(',', '.')) ?? 0;

    tasaI = null;
    tasaJ = null;
    tasaEA = null;
    resultado = "";

    if (m <= 0) {
      setState(() {
        resultado = "Por favor ingresa un número de capitalizaciones válido.";
      });
      return;
    }

    switch (calcular) {
      case "Tasa periódica (i)":
        if (j > 0 && m > 0) {
          final i = j / m;
          tasaI = i;
          tasaJ = j;
          tasaEA = (pow(1 + (j / 100) / m, m) - 1) * 100;
          resultado = "Tasa periódica (i): ${i.toStringAsFixed(2)} %";
        }
        break;

      case "Tasa nominal anual (j)":
        if (iPct > 0 && m > 0) {
          final jCalc = iPct * m;
          tasaI = iPct;
          tasaJ = jCalc;
          tasaEA = (pow(1 + (iPct / 100), m) - 1) * 100;
          resultado = "Tasa nominal anual (j): ${jCalc.toStringAsFixed(2)} %";
        }
        break;

      case "Tasa Efectiva Anual (EA)":
        if (j > 0 && m > 0) {
          final i = (j / 100) / m;
          final ea = (pow(1 + i, m) - 1) * 100;
          tasaI = j / m;
          tasaJ = j;
          tasaEA = ea.toDouble();
          resultado = "Tasa Efectiva Anual (EA): ${ea.toStringAsFixed(2)} %";
        }
        break;
    }

    setState(() {});
  }

  Widget _buildTable() {
    if (tasaI == null || tasaJ == null || tasaEA == null)
      return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tabla comparativa",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.green.shade800,
            )),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.green.shade300, width: 1),
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.green.shade100),
              children: [
                _cell("Concepto", bold: true),
                _cell("Valor", bold: true),
              ],
            ),
            TableRow(children: [
              _cell("Tasa periódica (i)"),
              _cell("${tasaI!.toStringAsFixed(2)} %"),
            ]),
            TableRow(children: [
              _cell("Tasa nominal anual (j)"),
              _cell("${tasaJ!.toStringAsFixed(2)} %"),
            ]),
            TableRow(children: [
              _cell("Tasa efectiva anual (EA)"),
              _cell("${tasaEA!.toStringAsFixed(2)} %"),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _cell(String text, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasas de Interés',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text("Calculadora de Tasas",
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: calcular,
            items: const [
              DropdownMenuItem(
                  value: "Tasa periódica (i)",
                  child: Text("Calcular i (tasa por periodo)")),
              DropdownMenuItem(
                  value: "Tasa nominal anual (j)",
                  child: Text("Calcular j (nominal anual)")),
              DropdownMenuItem(
                  value: "Tasa Efectiva Anual (EA)",
                  child: Text("Calcular EA (efectiva anual)")),
            ],
            onChanged: (v) {
              setState(() {
                calcular = v!;
                resultado = "";
                tasaI = null;
                tasaJ = null;
                tasaEA = null;
                _cargarEjemplo(calcular);
              });
            },
            decoration:
                const InputDecoration(labelText: "¿Qué deseas calcular?"),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: nominalController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Tasa nominal anual (j%)",
              hintText: "Ej: 24",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: periodsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Capitalizaciones por año (m)",
              hintText: "Ej: 12",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          if (calcular == "Tasa nominal anual (j)") ...[
            const SizedBox(height: 12),
            TextField(
              controller: periodRateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Tasa periódica (i%)",
                hintText: "Ej: 2",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
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
          const SizedBox(height: 20),
          _buildTable(),
        ],
      ),
    );
  }
}
