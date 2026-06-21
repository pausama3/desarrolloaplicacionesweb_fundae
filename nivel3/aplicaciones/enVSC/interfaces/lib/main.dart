import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

/// Widget Raíz: Configura el entorno gráfico global de la aplicación.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laboratorio de Interfaces',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const PantallaLaboratorio(),
    );
  }
}

/// Vista Principal: Implementa un StatefulWidget para gestionar 
/// las transformaciones de apariencia basadas en eventos de usuario.
class PantallaLaboratorio extends StatefulWidget {
  const PantallaLaboratorio({super.key});

  @override
  State<PantallaLaboratorio> createState() => _PantallaLaboratorioState();
}

class _PantallaLaboratorioState extends State<PantallaLaboratorio> {
  
  // VARIABLES DE ESTADO: Controlan las transformaciones dinámicas de la UI
  int _contadorClicks = 0;
  bool _componenteActivo = false;

  /// Modifica el estado interno incrementando el contador aritmético.
  void _registrarClick() {
    setState(() {
      _contadorClicks++;
    });
  }

  /// Alterna el estado booleano para transformar la apariencia de los componentes.
  void _conmutarEstado() {
    setState(() {
      _componenteActivo = !_componenteActivo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Árboles, Agrupaciones y Estados'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        
        // ============================================================
        // 1. AGRUPACIÓN LINEAL PRINCIPAL (Multi-child: Column)
        // ============================================================
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laboratorio Técnico de UI',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // ============================================================
            // 2. TRANSFORMACIONES VISUALES SEGÚN EVENTOS (Reactividad)
            // ============================================================
            const Text(
              'Transformación de Apariencia por Evento',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            
            // Contenedor animado que muta su aspecto físico según el estado actual
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                // Transformación de color dinámica según la variable '_componenteActivo'
                color: _componenteActivo ? Colors.teal[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(_componenteActivo ? 24.0 : 8.0), // Muta el radio
              ),
              child: Column(
                children: [
                  Text(
                    _componenteActivo ? 'ESTADO: ACTIVO / OPTIMIZADO' : 'ESTADO: INACTIVO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _componenteActivo ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Capturador de eventos táctiles incorporado directamente en la interfaz
                  ElevatedButton(
                    onPressed: _conmutarEstado, // Dispara la mutación del estado
                    child: const Text('Disparar Evento de Transformación'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ============================================================
            // 3. ANIDAMIENTOS COMPUESTOS Y AGRUPACIONES (Row + Stack)
            // ============================================================
            const Text(
              'Agrupación Lineal (Row) y Capas (Stack)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            
            // Fila organizativa que distribuye dos bloques independientes en horizontal
            Row(
              children: [
                // Bloque izquierdo: Ilustración de anidamiento simple (child)
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.blue[100],
                    child: const Center(
                      // Anidamiento estructural estricto: Center -> Padding -> Text
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Anidamiento Nodo Único (child)', textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Bloque derecho: Agrupación en profundidad (Stack)
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.purple[50],
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Capa base: Icono de gran tamaño
                          Icon(Icons.mail_outline, size: 60, color: Colors.purple[300]),
                          // Capa superior: Badge de notificación posicionado en coordenadas específicas
                          Positioned(
                            top: 15,
                            right: 25,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                '9+',
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // ============================================================
            // 4. INSTANCIACIÓN DE COMPONENTES PERSONALIZADOS REUTILIZABLES
            // ============================================================
            const Text(
              'Componentes Modulares Reutilizables',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            
            // Inyección de componentes propios pasándole los argumentos requeridos
            BloqueContador(
              etiqueta: 'Módulo de Rendimiento Alfa',
              valorContador: _contadorClicks,
              onBotonPulsado: _registrarClick, // Inyección de comportamiento por callback
            ),
            const SizedBox(height: 12),
            BloqueContador(
              etiqueta: 'Módulo de Rendimiento Beta',
              valorContador: _contadorClicks,
              onBotonPulsado: _registrarClick,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// COMPONENTE PERSONALIZADO (Custom Widget)
// ============================================================================

/// Componente modular encapsulado de tipo StatelessWidget. Recibe datos de 
/// configuración y funciones de comportamiento desde su widget padre.// ============================================================================
// COMPONENTE PERSONALIZADO (Custom Widget) - CORREGIDO
// ============================================================================

/// Componente modular encapsulado de tipo StatelessWidget. Recibe datos de 
/// configuración y funciones de comportamiento desde su widget padre.
class BloqueContador extends StatelessWidget {
  final String etiqueta;
  final int valorContador;
  final VoidCallback onBotonPulsado; // Callback formal para delegar el evento clic

  const BloqueContador({
    super.key,
    required this.etiqueta,
    required this.valorContador,
    required this.onBotonPulsado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // 🟢 CORRECTO: El borde va aquí, directamente en el BoxDecoration
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            // 🟢 CORRECTO: Usamos la constante global Colors.black con la nueva sintaxis
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sub-árbol izquierdo: Datos informativos del componente
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                etiqueta,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                'Métricas registradas: $valorContador',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          // Sub-árbol derecho: Botón operativo independiente
          IconButton.filled(
            onPressed: onBotonPulsado, // Ejecuta la función inyectada del padre
            icon: const Icon(Icons.add_moderator),
          ),
        ],
      ),
    );
  }
}