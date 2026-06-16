import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

// El caparazón de la app sigue igual, solo cambia el 'home'
class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Básica',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple
        ),
        useMaterial3: true,
      ),
      // 👈 ARRANCA EN EL MENÚ, NO EN LA CALCULADORA
      home: const CalculadoraMenu(), 
    );
  }
}

// 📄 NUEVA PANTALLA: EL MENÚ PRINCIPAL
class CalculadoraMenu extends StatelessWidget {
  const CalculadoraMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dojo Samurái'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Bienvenido!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20), // Espacio en blanco
            ElevatedButton(
              onPressed: () {
                // 🚀 AQUÍ ESTÁ LA MAGIA PARA CAMBIAR DE PANTALLA
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalculadoraHome(),
                  ),
                );
              },
              child: const Text('Abrir Calculadora'),
            ),
          ],
        ),
      ),
    );
  }
}

// 📄 TU PANTALLA DE LA CALCULADORA (Sigue igual que antes)
class CalculadoraHome extends StatefulWidget {
  const CalculadoraHome({super.key});

  @override
  State<CalculadoraHome> createState() => _CalculadoraHomeState();
}

class _CalculadoraHomeState extends State<CalculadoraHome> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: const Text('Calculadora Básica'),
  ),
  body: Center(
    child: SizedBox(
      width: 550, // 1. 👈 Fijamos el ancho total para las 5 columnas en el centro
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // 2. 👈 Contrae la columna verticalmente
        children: <Widget>[
          
          // ──────── FILA 1 ────────
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('2nd'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('deg'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('sin'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('cos'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('tan'))),
            ],
          ),
          
          const SizedBox(height: 10),

          // ──────── FILA 2 ────────
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('xy'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('lg'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('ln'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('y'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('x'))),
            ],
          ),
          
          const SizedBox(height: 10),

          // ──────── FILA 3 ────────
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('raiz'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('borrar'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('clear'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('%'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('dividir'))),
            ],
          ),

          const SizedBox(height: 10),

          // ──────── FILA 4 ────────
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('x'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('7'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('8'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('9'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('multiplicar'))),
            ],
          ),
          
          const SizedBox(height: 10),

          // ──────── FILA 5 ────────
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('1/x'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('4'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('5'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('6'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('restar'))),
            ],
          ),

          const SizedBox(height: 10),

          // ──────── FILA 6 ────────
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('pi'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('1'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('2'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('3'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('sumar'))),
            ],
          ),

          const SizedBox(height: 10),

          // ──────── FILA 7 ────────
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('x'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('e'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('0'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text(','))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('igual'))),
            ],
          ),

        ],
      ),
    ),
  ),
);
  }
}
