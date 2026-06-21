import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CalculadoraApp());
}

// ==========================================
// MÓDULO RAÍZ: CONFIGURACIÓN DE LA APLICACIÓN
// ==========================================

/// Widget raíz de la aplicación. Configura el estado global de los temas
/// visuales (Claro y Oscuro) exigidos en los requerimientos del proyecto.
class CalculadoraApp extends StatefulWidget {
  const CalculadoraApp({super.key});

  @override
  State<CalculadoraApp> createState() => _CalculadoraAppState();
}

class _CalculadoraAppState extends State<CalculadoraApp> {
  // Define la persistencia del modo visual activo (Claro por defecto)
  ThemeMode _themeMode = ThemeMode.light;

  /// Alterna el estado del tema global entre los modos Claro y Oscuro.
  void _alternarTema() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Básica',
      debugShowCheckedModeBanner: false,
      
      // Configuración de la paleta de colores para el Modo Claro
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      
      // Configuración de la paleta de colores para el Modo Oscuro
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      
      themeMode: _themeMode,
      home: CalculadoraMenu(
        onCambiarTema: _alternarTema,
        esModoOscuro: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

// ==========================================
// VISTA: VISTA O PANTALLA PRINCIPAL DEL MENÚ
// ==========================================

/// Pantalla de bienvenida que actúa como pasarela de navegación y
/// centro de control para la accesibilidad del tema visual.
class CalculadoraMenu extends StatelessWidget {
  final VoidCallback onCambiarTema;
  final bool esModoOscuro;

  const CalculadoraMenu({
    super.key,
    required this.onCambiarTema,
    required this.esModoOscuro,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dojo Samurái'),
        actions: [
          // Control de accesibilidad para la conmutación de temas
          IconButton(
            icon: Icon(esModoOscuro ? Icons.light_mode : Icons.dark_mode),
            tooltip: esModoOscuro ? 'Cambiar a Modo Claro' : 'Cambiar a Modo Oscuro',
            onPressed: onCambiarTema,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Bienvenido!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Tema actual: ${esModoOscuro ? "Modo Oscuro 🌙" : "Modo Claro ☀️"}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalculadoraHome(),
                  ),
                );
              },
              icon: const Icon(Icons.calculate),
              label: const Text('Abrir Calculadora'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// VISTA: ENTORNO DE TRABAJO DE LA CALCULADORA
// ==========================================

/// Punto de entrada del entorno de la calculadora funcional.
class CalculadoraHome extends StatefulWidget {
  const CalculadoraHome({super.key});

  @override
  State<CalculadoraHome> createState() => _CalculadoraHomeState();
}

class _CalculadoraHomeState extends State<CalculadoraHome> {
  
  // ------------------------------------------
  // 1. VARIABLES DE ESTADO Y CONTROLADORES
  // ------------------------------------------
  
  // Controlador para canalizar los datos de entrada/salida del TextField
  final TextEditingController _pantallaController = TextEditingController(text: '0');
  
  // Nodo de enfoque encargado de interceptar eventos del teclado físico
  late final FocusNode _focusNode;
  
  // Variables de cómputo aritmético interno
  num _resultado = 0;
  num numero = 0;
  
  // Estructuras de datos lineales para el procesamiento en cascada
  final _operaciones = <num>[];
  final _operadores = <String>[];
  final List<String> _historial = [];

  // ------------------------------------------
  // 2. MÉTODOS DEL CICLO DE VIDA (LIFECYCLE)
  // ------------------------------------------

  @override
  void initState() {
    super.initState();
    
    // Suscripción al gestor de eventos de teclado físico mediante el FocusNode
    _focusNode = FocusNode(onKeyEvent: (node, event) {
      if (event is KeyDownEvent) {
        final String? tecla = event.character;

        // Mapeo estructurado de teclas de control del sistema
        if (event.logicalKey == LogicalKeyboardKey.backspace) {
          _borrar();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.equal) {
          _calcular();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.escape) {
          _clear();
          return KeyEventResult.handled;
        }

        // Mapeo e inserción automática de caracteres aritméticos válidos
        if (tecla != null && '0123456789+-*/'.contains(tecla)) {
          _introducirNumero(tecla);
          return KeyEventResult.handled;
        }

        // Intercepción y aislamiento defensivo ante caracteres no permitidos
        setState(() {
          _pantallaController.text = 'Error: Entrada inválida';
        });
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    });
  }

  @override
  void dispose() {
    // Liberación explícita de punteros de memoria para mitigar fugas (Memory Leaks)
    _focusNode.dispose();
    _pantallaController.dispose();
    super.dispose();
  }

  // ------------------------------------------
  // 3. ACCIONES DIRECTAS DE LA INTERFAZ (UI)
  // ------------------------------------------

  /// Concatena los dígitos u operadores seleccionados en el panel numérico.
  void _introducirNumero(String botonNumero) {
    setState(() { 
      if (_pantallaController.text == '0' || _pantallaController.text.startsWith('Error')) {
        _pantallaController.text = botonNumero;
      } else {
        _pantallaController.text = _pantallaController.text + botonNumero; 
      }
    }); 
  }

  /// Remueve el último elemento de la cadena de texto actual (Efecto Backspace).
  void _borrar() {
    setState(() {
      String texto = _pantallaController.text;
      if (texto.startsWith('Error')) {
        _pantallaController.text = '0';
        return;
      }
      if (texto.length > 1) {
        _pantallaController.text = texto.substring(0, texto.length - 1);
      } else {
        _pantallaController.text = '0';
      }
    });
  }

  /// Restablece el entorno de ejecución, buffers aritméticos y la interfaz gráfica.
  void _clear() {
    setState(() {
      _pantallaController.text = '0';
      _resultado = 0;
      numero = 0;
      _operaciones.clear();
      _operadores.clear();
    });
  }

  // ------------------------------------------
  // 4. MOTOR DE PROCESAMIENTO Y TOKENIZACIÓN
  // ------------------------------------------

  /// Analiza léxicamente la cadena de la pantalla (Tokenización), separando
  /// los operandos numéricos de sus respectivos operadores aritméticos.
  void _calcular(){
    setState(() {
      _resultado = 0;
      String formula = _pantallaController.text;

      if (formula.startsWith('Error')) return;

      for(int i = 0; i < formula.length; i++){
        switch(formula[i]){
          case '0': numero = numero * 10; break;
          case '1': numero = (numero * 10) + 1; break;
          case '2': numero = (numero * 10) + 2; break;
          case '3': numero = (numero * 10) + 3; break;
          case '4': numero = (numero * 10) + 4; break;
          case '5': numero = (numero * 10) + 5; break;
          case '6': numero = (numero * 10) + 6; break;
          case '7': numero = (numero * 10) + 7; break;
          case '8': numero = (numero * 10) + 8; break;
          case '9': numero = (numero * 10) + 9; break;
          case '-':
            _operaciones.add(numero);
            _operadores.add('-');
            numero = 0; 
            break;
          case '*':
            _operaciones.add(numero);
            _operadores.add('*');
            numero = 0; 
            break;
          case '/':
            _operaciones.add(numero);
            _operadores.add('/');
            numero = 0; 
            break;
          case '+':
            _operaciones.add(numero);
            _operadores.add('+');
            numero = 0; 
            break;
        }
      }
      _calcularResultado();
    });
  }

  /// Orquesta la resolución matemática final invocando las subrutinas aritméticas
  /// bajo un bloque de seguridad robusto contra excepciones en tiempo de ejecución.
  void _calcularResultado() {
    try {
      // Sella la operación añadiendo el último operando almacenado en la recámara
      _operaciones.add(numero);
      numero = 0; 

      if (_operaciones.length < 2) return;
      String formulaOriginal = _pantallaController.text;
      
      // Ejecución ordenada respetando de forma estricta la prioridad matemática
      _dividir();
      if (_pantallaController.text == 'Error: División por 0') {
        _operaciones.clear();
        _operadores.clear();
        return;
      }
      
      _multiplicar();
      _restar();
      _sumar();
      
      // Control de formato estético para la salida tipográfica (Entero vs Decimal)
      String resultadoFormateado;
      if (_resultado % 1 == 0) {
        resultadoFormateado = _resultado.toInt().toString();
      } else {
        resultadoFormateado = _resultado.toString().replaceAll('.', ',');
      }

      setState(() {
        _pantallaController.text = resultadoFormateado;
        // Inserción prioritaria en el histórico (Última operación en el índice 0)
        _historial.insert(0, '$formulaOriginal = $resultadoFormateado');
      });

      // Liberación de estructuras para habilitar ciclos de cálculo subsecuentes
      _operaciones.clear();
      _operadores.clear();

    } catch (e) {
      // Captura y aislamiento de desbordamientos de índice o errores sintácticos
      setState(() {
        _pantallaController.text = 'Error: Expresión mal formada';
        _operaciones.clear();
        _operadores.clear();
        numero = 0;
      });
    }
  }

  // ------------------------------------------
  // 5. SUBRUTINAS DE COMPUTO SECUENCIAL
  // ------------------------------------------

  /// Resuelve de manera iterativa todas las operaciones de división '/'
  /// reorganizando los índices remanentes mediante compresión en cascada.
  void _dividir(){
    for (int i = 0; i < _operadores.length; i++) {
      if (_operadores[i] == '/') {          
        if (_operaciones[i+1] == 0) {
          _pantallaController.text = 'Error: División por 0';
          return;
        }
        _resultado = _operaciones[i] / _operaciones[i+1];
        _operaciones[i] = _resultado;
        _operaciones.removeAt(i+1);
        _operadores.removeAt(i);    
        i--;                        
      }
    }
  }   

  /// Resuelve todas las operaciones de multiplicación '*' de la estructura.
  void _multiplicar(){
    for (int i = 0; i < _operadores.length; i++) {
      if (_operadores[i] == '*') {          
        _resultado = _operaciones[i] * _operaciones[i+1];
        _operaciones[i] = _resultado;
        _operaciones.removeAt(i+1); 
        _operadores.removeAt(i);    
        i--;                        
      }
    }
  }

  /// Resuelve todas las operaciones de sustracción '-' de la estructura.
  void _restar(){
    for (int i = 0; i < _operadores.length; i++) {
      if (_operadores[i] == '-') {          
        _resultado = _operaciones[i] - _operaciones[i+1];
        _operaciones[i] = _resultado;
        _operaciones.removeAt(i+1); 
        _operadores.removeAt(i);   
        i--;                        
      }
    }
  }

  /// Resuelve todas las operaciones de adición '+' de la estructura.
  void _sumar(){
    for (int i = 0; i < _operadores.length; i++) {
      if (_operadores[i] == '+') {          
        _resultado = _operaciones[i] + _operaciones[i+1];
        _operaciones[i] = _resultado;
        _operaciones.removeAt(i+1); 
        _operadores.removeAt(i);    
        i--;                        
      }
    }
  }

  // ------------------------------------------
  // 6. ÁRBOL DE WIDGETS DE LA INTERFAZ GRÁFICA
  // ------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Evaluación del contexto de color estructural para acomodar contrastes dinámicos
    final bool esOscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Calculadora Básica'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: 550, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, 
                children: <Widget>[

                  // TextField unificado que actúa como display interactivo (Teclado + Ratón)
                  TextField(
                    controller: _pantallaController,
                    focusNode: _focusNode,
                    autofocus: true,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: esOscuro ? Colors.grey[900] : Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: esOscuro ? Colors.grey[700]! : Colors.grey[400]!),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Fila de Controles Operativos 3
                  Row(
                    children: [
                      Expanded(child: Tooltip(message: 'Borrar última cifra', child: ElevatedButton(onPressed: () => _borrar(), child: const Text('borrar')))),
                      const SizedBox(width: 12),
                      Expanded(child: Tooltip(message: 'Limpiar pantalla y reiniciar', child: ElevatedButton(onPressed: () => _clear(), child: const Text('clear')))),
                      const SizedBox(width: 12),
                      Expanded(child: Tooltip(message: 'Dividir', child: ElevatedButton(onPressed: () => _introducirNumero('/'), child: const Text('/')))),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Fila Numérica y Operativa 4
                  Row(
                    children: [
                      Expanded(child: Tooltip(message: 'Número 7', child: ElevatedButton(onPressed: () => _introducirNumero('7'), child: const Text('7')))),
                      const SizedBox(width: 12),
                      Expanded(child: Tooltip(message: 'Número 8', child: ElevatedButton(onPressed: () => _introducirNumero('8'), child: const Text('8')))),
                      const SizedBox(width: 12),
                      Expanded(child: Tooltip(message: 'Número 9', child: ElevatedButton(onPressed: () => _introducirNumero('9'), child: const Text('9')))),
                      const SizedBox(width: 12),
                      Expanded(child: Tooltip(message: 'Multiplicar', child: ElevatedButton(onPressed: () => _introducirNumero('*'), child: const Text('*')))),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Fila Numérica y Operativa 5
                  Row(
                    children: [
                      Expanded(child: Tooltip(message: 'Número 4', child: ElevatedButton(onPressed: () => _introducirNumero('4'), child: const Text('4')))),
                      const SizedBox(width: 12),
                      Expanded(child: Tooltip(message: 'Número 5', child: ElevatedButton(onPressed: () => _introducirNumero('5'), child: const Text('5')))),
                      const SizedBox(width: 12),
                      Expanded(child: Tooltip(message: 'Número 6', child: ElevatedButton(onPressed: () => _introducirNumero('6'), child: const Text('6')))),
                      const SizedBox(width: 12),
                      Expanded(child: Tooltip(message: 'Restar', child: ElevatedButton(onPressed: () => _introducirNumero('-'), child: const Text('-')))),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Fila Numérica y Operativa 6
                  Row(
                    children: [
                      Expanded(child: Tooltip(message: 'Número 1', child: ElevatedButton(onPressed: () => _introducirNumero('1'), child: const Text('1')))),
                      const SizedBox(width: 12),
                      Expanded(child: Tooltip(message: 'Número 2', child: ElevatedButton(onPressed: () => _introducirNumero('2'), child: const Text('2')))),
                      const SizedBox(width: 12),
                      Expanded(child: Tooltip(message: 'Número 3', child: ElevatedButton(onPressed: () => _introducirNumero('3'), child: const Text('3')))),
                      const SizedBox(width: 12),    
                      Expanded(child: Tooltip(message: 'Sumar', child: ElevatedButton(onPressed: () => _introducirNumero('+'), child: const Text('+')))),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Fila de Cierre 7
                  Row(
                    children: [
                      Expanded(child: Tooltip(message: 'Número 0', child: ElevatedButton(onPressed: () => _introducirNumero('0'), child: const Text('0')))),
                      const SizedBox(width: 12),
                      Expanded(child: Tooltip(message: 'Calcular resultado', child: ElevatedButton(onPressed: () => _calcular(), child: const Text('=')))),
                    ],
                  ),

                  // Sección del histórico visual de transacciones aritméticas
                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.history, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      const Text(
                        'Historial de operaciones',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 130, 
                    decoration: BoxDecoration(
                      color: esOscuro ? Colors.grey[950] : Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: esOscuro ? Colors.grey[800]! : Colors.grey[300]!),
                    ),
                    child: _historial.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay operaciones aún.',
                              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _historial.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                child: Text(
                                  _historial[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'monospace',
                                    color: esOscuro ? Colors.white70 : Colors.black87,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}