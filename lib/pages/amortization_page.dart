import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class AmortizationPage extends StatefulWidget {
  const AmortizationPage({super.key});

  @override
  State<AmortizationPage> createState() => _AmortizationPageState();
}

class _AmortizationPageState extends State<AmortizationPage> {
  final principalCtrl = TextEditingController(); // P - Principal
  final tasaCtrl = TextEditingController(); // i - Tasa
  final periodosCtrl = TextEditingController(); // n - Periodos

  String sistema = 'Francés';
  String resultado = '';
  String ejemplo = '';
  String teoriaYFormula = '';
  List<Map<String, dynamic>> tablaAmortizacion = [];
  int _paginaActual = 0; // Para paginación
  final int _periodosPorPagina = 10;

  @override
  void initState() {
    super.initState();
    _cargarEjemplo(sistema);
    _cargarTeoriaYFormula(sistema);
  }

  void _cargarEjemplo(String tipo) {
    switch (tipo) {
      case 'Francés':
        ejemplo = 'Ejemplo: Préstamo de \$10,000 al 10% mensual por 24 meses.\n'
            'Cuota fija: \$1,113.00\n'
            'Interés mes 1: \$1,000.00\n'
            'Amortización mes 1: \$113.00\n\n'
            '💡 En sistema francés, al inicio se pagan más intereses y menos capital.';
        break;
      case 'Alemán':
        ejemplo = 'Ejemplo: Préstamo de \$10,000 al 10% mensual por 24 meses.\n'
            'Amortización fija: \$416.67\n'
            'Cuota mes 1: \$1,416.67\n'
            'Cuota mes 24: \$427.08\n\n'
            '💡 En sistema alemán, la amortización es constante y las cuotas disminuyen.';
        break;
      case 'Americano':
        ejemplo = 'Ejemplo: Préstamo de \$10,000 al 10% mensual por 24 meses.\n'
            'Cuotas interés: \$1,000 mensual\n'
            'Última cuota: \$11,000 (capital + interés)\n\n'
            '💡 En sistema americano, solo se pagan intereses hasta el final.';
        break;
    }
  }

  void _cargarTeoriaYFormula(String tipo) {
    switch (tipo) {
      case 'Francés':
        teoriaYFormula = "SISTEMA FRANCÉS (CUOTA FIJA)\n\n"
            "CARACTERÍSTICAS:\n"
            "• Cuota CONSTANTE durante todo el plazo\n"
            "• Al inicio: MÁS intereses, MENOS amortización\n"
            "• Al final: MENOS intereses, MÁS amortización\n"
            "• Intereses sobre saldo decreciente\n\n"
            "FÓRMULA CUOTA:\n"
            "A = P × [i(1+i)ⁿ] / [(1+i)ⁿ - 1]\n\n"
            "EVOLUCIÓN TÍPICA:\n"
            "Mes 1: Interés alto, Amortización baja\n"
            "Mes n: Interés bajo, Amortización alta";
        break;

      case 'Alemán':
        teoriaYFormula = "SISTEMA ALEMÁN (AMORTIZACIÓN FIJA)\n\n"
            "CARACTERÍSTICAS:\n"
            "• Amortización de capital CONSTANTE\n"
            "• Cuotas DISMINUYEN con el tiempo\n"
            "• Intereses sobre saldo decreciente\n"
            "• Cuota inicial más alta\n\n"
            "FÓRMULAS:\n"
            "Amortización = P / n\n"
            "Interés t = Saldo t × i\n"
            "Cuota t = Amortización + Interés t";
        break;

      case 'Americano':
        teoriaYFormula = "SISTEMA AMERICANO (INTERÉS PURO)\n\n"
            "CARACTERÍSTICAS:\n"
            "• Solo se pagan INTERESES periódicamente\n"
            "• Capital se paga COMPLETO al vencimiento\n"
            "• Cuotas CONSTANTES de interés\n"
            "• Última cuota muy alta\n\n"
            "FÓRMULAS:\n"
            "Interés periódico = P × i\n"
            "Cuota t = P × i (para t < n)\n"
            "Cuota n = P + (P × i)";
        break;
    }
  }

  void _calcular() {
    final P = double.tryParse(principalCtrl.text) ?? 0.0;
    final iPct = double.tryParse(tasaCtrl.text) ?? 0.0;
    final n = int.tryParse(periodosCtrl.text) ?? 0;

    final i = iPct / 100;
    tablaAmortizacion.clear();
    _paginaActual = 0;

    try {
      switch (sistema) {
        case 'Francés':
          _calcularFrances(P, i, n);
          break;
        case 'Alemán':
          _calcularAleman(P, i, n);
          break;
        case 'Americano':
          _calcularAmericano(P, i, n);
          break;
      }
      setState(() {});
    } catch (e) {
      setState(() {
        resultado = 'Error en el cálculo: $e';
      });
    }
  }

  void _calcularFrances(double P, double i, int n) {
    if (i == 0) {
      final cuota = P / n;
      final totalCuotas = cuota * n;
      resultado =
          'Cuota constante: \$${cuota.toStringAsFixed(2)} (sin interés)\n'
          'Total a pagar: \$${totalCuotas.toStringAsFixed(2)}';
      return;
    }

    final factor = (i * pow(1 + i, n)) / (pow(1 + i, n) - 1);
    final cuota = P * factor;
    final totalCuotas = cuota * n;
    final interesTotal = totalCuotas - P;

    double saldo = P;
    resultado = 'Cuota constante: \$${cuota.toStringAsFixed(2)}\n\n'
        /*'Total a pagar: \$${totalCuotas.toStringAsFixed(2)}\n'
        'Interés total: \$${interesTotal.toStringAsFixed(2)}\n\n'*/
        'Desglose primeros 3 períodos:\n';

    for (int periodo = 1; periodo <= n; periodo++) {
      final interes = saldo * i;
      final amortizacion = cuota - interes;
      saldo -= amortizacion;

      tablaAmortizacion.add({
        'periodo': periodo,
        'cuota': cuota,
        'interes': interes,
        'amortizacion': amortizacion,
        'saldo': saldo
      });

      if (periodo <= 3) {
        resultado += 'Período $periodo: Int=\$${interes.toStringAsFixed(2)}, '
            'Amort=\$${amortizacion.toStringAsFixed(2)}\n';
      }
    }

    // Agregar análisis del último período
    resultado += '\nÚltimo período:\n';
    resultado +=
        'Período $n: Int=\$${tablaAmortizacion.last['interes'].toStringAsFixed(2)}, '
        'Amort=\$${tablaAmortizacion.last['amortizacion'].toStringAsFixed(2)}';
  }

  void _calcularAleman(double P, double i, int n) {
    final amortizacionConstante = P / n;
    double saldo = P;
    double totalCuotas = 0.0;

    resultado =
        'Amortización constante: \$${amortizacionConstante.toStringAsFixed(2)}\n\nDesglose primeros 3 períodos:\n';

    for (int periodo = 1; periodo <= n; periodo++) {
      final interes = saldo * i;
      final cuota = amortizacionConstante + interes;
      saldo -= amortizacionConstante;
      totalCuotas += cuota;

      tablaAmortizacion.add({
        'periodo': periodo,
        'cuota': cuota,
        'interes': interes,
        'amortizacion': amortizacionConstante,
        'saldo': saldo
      });

      if (periodo <= 3) {
        resultado += 'Período $periodo: Cuota=\$${cuota.toStringAsFixed(2)}, '
            'Int=\$${interes.toStringAsFixed(2)}\n';
      }
    }

    // Agregar total al resultado
    resultado += '\nTotal a pagar: \$${totalCuotas.toStringAsFixed(2)}\n'
        'Interés total: \$${(totalCuotas - P).toStringAsFixed(2)}';
  }

  void _calcularAmericano(double P, double i, int n) {
    final interesPeriodico = P * i;
    final totalCuotas = (interesPeriodico * (n - 1)) + (P + interesPeriodico);

    resultado = 'Interés periódico: \$${interesPeriodico.toStringAsFixed(2)}\n'
        'Última cuota: \$${(P + interesPeriodico).toStringAsFixed(2)}\n\n'
        /*'Total a pagar: \$${totalCuotas.toStringAsFixed(2)}\n'
        'Interés total: \$${(interesPeriodico * n).toStringAsFixed(2)}\n\n'*/
        'Desglose primeros 3 períodos:\n';

    for (int periodo = 1; periodo <= n; periodo++) {
      final cuota = periodo == n ? P + interesPeriodico : interesPeriodico;
      final amortizacion = periodo == n ? P : 0.0;
      final saldo = periodo == n ? 0.0 : P;

      tablaAmortizacion.add({
        'periodo': periodo,
        'cuota': cuota,
        'interes': interesPeriodico,
        'amortizacion': amortizacion,
        'saldo': saldo
      });

      if (periodo <= 3) {
        resultado += periodo == n
            ? 'Período $periodo: Cuota=\$${cuota.toStringAsFixed(2)} \n'
            : 'Período $periodo: Cuota=\$${cuota.toStringAsFixed(2)} \n';
      }
    }
  }

  Widget _buildControlesTabla() {
    if (tablaAmortizacion.isEmpty) return const SizedBox();

    final totalPaginas = (tablaAmortizacion.length / _periodosPorPagina).ceil();
    final inicio = _paginaActual * _periodosPorPagina;
    final fin = min(inicio + _periodosPorPagina, tablaAmortizacion.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                'Amortización (${inicio + 1}-$fin de ${tablaAmortizacion.length})',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 15)),
            if (totalPaginas > 1) ...[
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: _paginaActual > 0
                        ? () {
                            setState(() => _paginaActual--);
                          }
                        : null,
                  ),
                  Text('${_paginaActual + 1}/$totalPaginas',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: _paginaActual < totalPaginas - 1
                        ? () {
                            setState(() => _paginaActual++);
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ],
        ),

        // Slider para controlar cuántos períodos mostrar por página
        if (tablaAmortizacion.length > 5) ...[
          const SizedBox(height: 8),
          Text('Períodos por página: ${_periodosPorPagina.toInt()}',
              style: GoogleFonts.poppins(fontSize: 12)),
        ],

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTablaAmortizacion() {
    if (tablaAmortizacion.isEmpty) return const SizedBox();

    final inicio = _paginaActual * _periodosPorPagina;
    final fin = min(inicio + _periodosPorPagina, tablaAmortizacion.length);
    final periodosMostrar = tablaAmortizacion.sublist(inicio, fin);

    // Calcular totales de la página actual
    final totalCuotaPagina =
        periodosMostrar.fold(0.0, (sum, fila) => sum + fila['cuota']);
    final totalInteresPagina =
        periodosMostrar.fold(0.0, (sum, fila) => sum + fila['interes']);
    final totalAmortizacionPagina =
        periodosMostrar.fold(0.0, (sum, fila) => sum + fila['amortizacion']);

    // Calcular totales generales
    final totalCuotaGeneral =
        tablaAmortizacion.fold(0.0, (sum, fila) => sum + fila['cuota']);
    final totalInteresGeneral =
        tablaAmortizacion.fold(0.0, (sum, fila) => sum + fila['interes']);
    final totalAmortizacionGeneral =
        tablaAmortizacion.fold(0.0, (sum, fila) => sum + fila['amortizacion']);

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Período')),
              DataColumn(label: Text('Cuota')),
              DataColumn(label: Text('Interés')),
              DataColumn(label: Text('Amortización')),
              DataColumn(label: Text('Saldo')),
            ],
            rows: [
              ...periodosMostrar.map((fila) {
                return DataRow(cells: [
                  DataCell(Text(fila['periodo'].toString())),
                  DataCell(Text('\$${fila['cuota'].toStringAsFixed(2)}')),
                  DataCell(Text('\$${fila['interes'].toStringAsFixed(2)}')),
                  DataCell(
                      Text('\$${fila['amortizacion'].toStringAsFixed(2)}')),
                  DataCell(Text('\$${fila['saldo'].toStringAsFixed(2)}')),
                ]);
              }),
              // Fila de totales de la página
              DataRow(
                cells: [
                  DataCell(Text('Total ${inicio + 1}-$fin',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                  DataCell(Text('\$${totalCuotaPagina.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                  DataCell(Text('\$${totalInteresPagina.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                  DataCell(Text(
                      '\$${totalAmortizacionPagina.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                  DataCell(Text('',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                ],
              ),
            ],
          ),
        ),

        // Totales generales
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.teal.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.teal.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTALES GENERALES:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.teal.shade900,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total cuotas:',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  Text('\$${totalCuotaGeneral.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total intereses:',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  Text('\$${totalInteresGeneral.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total amortización:',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  Text('\$${totalAmortizacionGeneral.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
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
        title: Text('Sistemas de Amortización',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Calculadora de Amortización',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: sistema,
            items: const [
              DropdownMenuItem(
                  value: 'Francés', child: Text('Sistema Francés')),
              DropdownMenuItem(value: 'Alemán', child: Text('Sistema Alemán')),
              DropdownMenuItem(
                  value: 'Americano', child: Text('Sistema Americano')),
            ],
            onChanged: (v) {
              setState(() {
                sistema = v ?? 'Francés';
                _cargarEjemplo(sistema);
                _cargarTeoriaYFormula(sistema);
                principalCtrl.clear();
                tasaCtrl.clear();
                periodosCtrl.clear();
                resultado = '';
                tablaAmortizacion.clear();
                _paginaActual = 0;
              });
            },
            decoration:
                const InputDecoration(labelText: 'Sistema de amortización'),
          ),
          const SizedBox(height: 20),
          _input(principalCtrl, 'Principal del préstamo (P)',
              hint: 'Ej: 10000'),
          const SizedBox(height: 12),
          _input(tasaCtrl, 'Tasa i (%) por periodo', hint: 'Ej: 10'),
          const SizedBox(height: 12),
          _input(periodosCtrl, 'Número de periodos (n)', hint: 'Ej: 24'),
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
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                resultado,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900),
              ),
            ),
          if (tablaAmortizacion.isNotEmpty) ...[
            _buildControlesTabla(),
            _buildTablaAmortizacion(),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Text(
              teoriaYFormula,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.teal.shade900,
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
              border: Border.all(color: Colors.teal.shade200),
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
