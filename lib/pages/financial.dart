import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinancialPage extends StatefulWidget {
  const FinancialPage({super.key});

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage> {
  final TextEditingController _amountInputController = TextEditingController();
  final TextEditingController _rateInputController = TextEditingController();
  final TextEditingController _timeInputController = TextEditingController();
  String _quota = "";

  void _clean() {
    setState(() {
      _rateInputController.clear();
      _amountInputController.clear();
      _timeInputController.clear();
      _quota = '';
    });
  }

  void _msgError(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text(
              "Error",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
  }

  void _calculateMonthlyPayment() {
    final amount = double.tryParse(_amountInputController.text);
    final rate = double.tryParse(_rateInputController.text);
    final years = double.tryParse(_timeInputController.text);

    if (amount == null || amount <= 0) {
      _msgError("Por favor ingrese un monto válido");
      return;
    }

    if (rate == null || rate < 0) {
      _msgError("Por favor ingrese una tasa de interés válida");
      return;
    }

    if (years == null || years <= 0) {
      _msgError("Por favor ingrese un tiempo en años válido");
      return;
    }

    final months = (years * 12).round();
    final monthlyRate = rate / 12 / 100;

    double monthlyPayment;

    if (monthlyRate == 0) {
      monthlyPayment = amount / months;
    } else {
      final numerator = amount * monthlyRate;
      final denominator = 1 - pow(1 + monthlyRate, -months);

      monthlyPayment = numerator / denominator;
    }

    setState(() {
      _quota = 'L ${monthlyPayment.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.orange,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.attach_money_rounded, color: Colors.orange),
            SizedBox(width: 5),
            const Text(
              "Calculadora Financiera",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                _quota.isNotEmpty ? _quota : 'L 0.00',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: _amountInputController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "Monto",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.wallet),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _rateInputController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: const InputDecoration(
                labelText: "Tasa de interés (Anual)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.balance),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _timeInputController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: const InputDecoration(
                labelText: "Tiempo (Años)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_month),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calcular'),
                  onPressed: () => _calculateMonthlyPayment(),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.delete),
                  label: const Text('Limpiar'),
                  onPressed: () => _clean(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountInputController.dispose();
    _rateInputController.dispose();
    _timeInputController.dispose();
    super.dispose();
  }
}
