import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _firstInputController = TextEditingController();
  final TextEditingController _secondInputController = TextEditingController();
  String _result = '';

  void _calculate(String operation) {
    final num1 = double.tryParse(_firstInputController.text);
    final num2 = double.tryParse(_secondInputController.text);

    if (num1 == null || num2 == null) {
      setState(() => _msgError('Ingrese números válidos!'));
      return;
    }

    double res;
    switch (operation) {
      case '+':
        res = num1 + num2;
        break;
      case '-':
        res = num1 - num2;
        break;
      case '*':
        res = num1 * num2;
        break;
      case '/':
        if (num2 == 0) {
          setState(() => _msgError('No se puede dividir por cero'));
          return;
        }
        res = num1 / num2;
        break;
      default:
        res = 0;
    }

    setState(() => _result = '$res');
  }

  void _clean() {
    setState(() {
      _firstInputController.clear();
      _secondInputController.clear();
      _result = '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calculate, color: Colors.green),
            SizedBox(width: 5),
            const Text(
              "Calculadora",
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
                _result.isNotEmpty ? _result : '0',
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
              controller: _firstInputController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "Primer número",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _secondInputController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: const InputDecoration(
                labelText: "Segundo número",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.numbers),
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
                  icon: const Icon(Icons.add),
                  label: const Text('Sumar'),
                  onPressed: () => _calculate('+'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.remove),
                  label: const Text('Restar'),
                  onPressed: () => _calculate('-'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.clear),
                  label: const Text('Multiplicar'),
                  onPressed: () => _calculate('*'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  icon: Text('/', style: TextStyle(color: Colors.white)),
                  label: const Text('Dividir'),
                  onPressed: () => _calculate('/'),
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
    _firstInputController.dispose();
    _secondInputController.dispose();
    super.dispose();
  }
}
