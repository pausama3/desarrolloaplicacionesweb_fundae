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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
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

// 📄 TU PANTALLA DE LA CALCULADORA
class CalculadoraHome extends StatefulWidget {
  const CalculadoraHome({super.key});

  @override
  State<CalculadoraHome> createState() => _CalculadoraHomeState();
}

class _CalculadoraHomeState extends State<CalculadoraHome> {
  String _pantalla = '0';
  num _resultado = 0;
  num numero = 0;
  final _operaciones = <num>[];
  final _operadores = <String>[];
  


  void _introducirNumero(String botonNumero) {
    setState(() { 
      if (_pantalla == '0') {
        _pantalla = botonNumero; 
      } else {
        _pantalla = _pantalla + botonNumero; 
      }
    }); 
  }
  void _calcular(){
    setState(() {
     for(int i=0; i<_pantalla.length; i++){
      switch(_pantalla[i]){
        case '0':
          numero = numero * 10;
          break;
        case '1':
          numero = (numero * 10) + 1;
          break;
        case '2':
          numero = (numero * 10) + 2;
          break;
        case '3':
          numero = (numero * 10) + 3;
          break;
        case '4':
          numero = (numero * 10) + 4;
          break;
        case '5':
          numero = (numero * 10) + 5;
          break;
        case '6':
          numero = (numero * 10) + 6;
          break;
        case '7':
          numero = (numero * 10) + 7;
          break;
        case '8':
          numero = (numero * 10) + 8;
          break;
        case '9':
          numero = (numero * 10) + 9;
          break;
        case '-':
          _resultado = _resultado - int.parse(_pantalla[i+1]);
          _operaciones.add(numero);
          _operadores.add('-');
          numero = 0; 
          break;
        case '*':
          _resultado = _resultado * int.parse(_pantalla[i+1]);
          _operaciones.add(numero);
          _operadores.add('*');
           numero = 0; 
          break;
        case '/':
          _resultado = _resultado / int.parse(_pantalla[i+1]);
          _operaciones.add(numero);
          _operadores.add('/');
          numero = 0; 
          break;
        case '+':
          _resultado = _resultado + int.parse(_pantalla[i+1]);
          _operaciones.add(numero);
          _operadores.add('+');
          numero = 0; 
          break;
      }
     }
    _calcularResultado();
    });
  }
  void _borrar() {
    setState(() {
      if (_pantalla.length > 1) {
        _pantalla = _pantalla.substring(0, _pantalla.length - 1);
      } else {
        _pantalla = '0';
      }
    });
  }
  void _clear() {
    setState(() {
      _pantalla = '0';
      _resultado = 0;
      numero = 0;
      _operaciones.clear();
      _operadores.clear();
    });
  }
  void _restar(){
    setState(() {
      for (int i = 0; i < _operadores.length; i++) {
        if (_operadores[i] == '-') {          
          _resultado = _operaciones[i] - _operaciones[i+1];
          _operaciones[i] = _resultado;
          _operaciones.removeAt(i+1); 
          _operadores.removeAt(i);   
          i--;                        
        }
      }
    });
  }
  void _multiplicar(){
    setState(() {
      for (int i = 0; i < _operadores.length; i++) {
        if (_operadores[i] == '*') {          
          _resultado = _operaciones[i] * _operaciones[i+1];
          _operaciones[i] = _resultado;
          _operaciones.removeAt(i+1); 
          _operadores.removeAt(i);    
          i--;                        
        }
      }
    });
  }
  void _dividir(){
    setState(() {
      for (int i = 0; i < _operadores.length; i++) {
        if (_operadores[i] == '/') {          
          _resultado = _operaciones[i] / _operaciones[i+1];
          _operaciones[i] = _resultado;
          _operaciones.removeAt(i+1);
          _operadores.removeAt(i);    
          i--;                        
        }
      }
    });
  }   
  void _sumar(){
    setState(() {
      for (int i = 0; i < _operadores.length; i++) {
        if (_operadores[i] == '+') {          
          _resultado = _operaciones[i] + _operaciones[i+1];
          _operaciones[i] = _resultado;
          _operaciones.removeAt(i+1); 
          _operadores.removeAt(i);    
          i--;                        
        }
      }
    });
  }
  void _calcularResultado() {
  setState(() {
    // 1. Guardamos el último número que estaba en la recámara
    _operaciones.add(numero);
    numero = 0; 

    // 🛡️ Protección básica por si acaso
    if (_operaciones.length < 2) return;
    _dividir();
    _multiplicar();
    _restar();
    _sumar();
    
    // 2. Mostramos el resultado final en la pantalla
    // Si el resultado es entero (ej: 14.0), mostramos "14" limpio
    if (_resultado % 1 == 0) {
      _pantalla = _resultado.toInt().toString();
    } else {
      _pantalla = _resultado.toString().replaceAll('.', ',');
    }

    // 3. 🧹 ¡MUY IMPORTANTE!: Vaciamos las listas para la siguiente operación
    _operaciones.clear();
    _operadores.clear();
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Calculadora Básica'),
      ),
      body: Center(
        child: SizedBox(
          width: 550, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, 
            children: <Widget>[

              Container(
                width: double.infinity, 
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[200], 
                  borderRadius: BorderRadius.circular(12), 
                  border: Border.all(color: Colors.grey[400]!), 
                ),
                child: Text(
                  _pantalla, 
                  textAlign: TextAlign.end, 
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace', 
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
               /* 
              // ──────── FILA 1 ────────
              Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('2nd'), child: const Text('2nd'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('deg'), child: const Text('deg'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('sin'), child: const Text('sin'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('cos'), child: const Text('cos'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('tan'), child: const Text('tan'))),
                ],
              ),
              
              const SizedBox(height: 10),

              // ──────── FILA 2 ────────
              Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('xy'), child: const Text('xy'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('lg'), child: const Text('lg'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('ln'), child: const Text('ln'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('y'), child: const Text('y'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('x'), child: const Text('x'))),
                ],
              ),
              
              const SizedBox(height: 10),
              */
              // ──────── FILA 3 ────────
              Row(
                children: [
                 // Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('raiz'), child: const Text('raiz'))),
                 // const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _borrar(), child: const Text('borrar'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _clear(), child: const Text('clear'))),
                  const SizedBox(width: 12),
                //  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('%'), child: const Text('%'))),
                  //const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('/'), child: const Text('/'))),
                ],
              ),

              const SizedBox(height: 10),

              // ──────── FILA 4 ────────
              Row(
                children: [
                  //Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('x'), child: const Text('x'))),
                  //const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('7'), child: const Text('7'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('8'), child: const Text('8'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('9'), child: const Text('9'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('*'), child: const Text('*'))),
                ],
              ),
              
              const SizedBox(height: 10),

              // ──────── FILA 5 ────────
              Row(
                children: [
                  //Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('1/x'), child: const Text('1/x'))),
                  //const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('4'), child: const Text('4'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('5'), child: const Text('5'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('6'), child: const Text('6'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('-'), child: const Text('-'))),
                ],
              ),

              const SizedBox(height: 10),

              // ──────── FILA 6 ────────
              Row(
                children: [
                  //Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('pi'), child: const Text('pi'))),
                  //const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('1'), child: const Text('1'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('2'), child: const Text('2'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('3'), child: const Text('3'))),
                  const SizedBox(width: 12),    

                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('+'), child: const Text('+'))),
                ],
              ),

              const SizedBox(height: 10),

              // ──────── FILA 7 ────────
              Row(
                children: [
                 // Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('x'), child: const Text('x'))),
                 // const SizedBox(width: 12),
                 // Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('e'), child: const Text('e'))),
                  //const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _introducirNumero('0'), child: const Text('0'))),
                  const SizedBox(width: 12),
                  //Expanded(child: ElevatedButton(onPressed: () => _introducirNumero(','), child: const Text(','))),
                  //const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => _calcular(), child: const Text('='))),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
