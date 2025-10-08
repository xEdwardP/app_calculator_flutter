import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _firstInputController = TextEditingController();
  final TextEditingController _secondInputController = TextEditingController();
  String _resultado = '';

  void _calcular(String operacion) {
    final num1 = double.tryParse(_firstInputController.text);
    final num2 = double.tryParse(_secondInputController.text);

    if (num1 == null || num2 == null) {
      setState(() => _resultado = 'Ingresa números válidos');
      return;
    }

    double res;
    switch (operacion) {
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
          setState(() => _resultado = 'No se puede dividir por cero');
          return;
        }
        res = num1 / num2;
        break;
      default:
        res = 0;
    }

    setState(() => _resultado = 'El resultado: $res');
  }

  void _msgError(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 5),
            const Text(
              "Error",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: Text(msg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculadora"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstInputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Primer número",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _secondInputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Segundo número",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => _calcular('+'),
                  child: const Text('+ Sumar'),
                ),
                ElevatedButton(
                  onPressed: () => _calcular('-'),
                  child: const Text('- Restar'),
                ),
                ElevatedButton(
                  onPressed: () => _calcular('*'),
                  child: const Text('* Multiplicar'),
                ),
                ElevatedButton(
                  onPressed: () => _calcular('/'),
                  child: const Text('/ Dividir'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _resultado,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
