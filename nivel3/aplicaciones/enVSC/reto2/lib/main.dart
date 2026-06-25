import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// ============================================================================
/// GESTIÓN DE ESTILOS, TIPOGRAFÍAS Y PALETAS DE COLORES (AppTheme)
/// ============================================================================
/// Clase encargada de centralizar la identidad visual de la aplicación.
/// Define las paletas de colores para ambos modos y expone los objetos [ThemeData].
class AppTheme {
  // Paleta de colores - Modo Claro
  static const Color lightPrimary = Color.fromARGB(255, 54, 1, 70);   // Morado profundo
  static const Color lightSecondary = Color(0xFF00796B);               // Teal / Turquesa
  static const Color lightAccent = Color(0xFFFF6D00);                  // Naranja brillante (Acento)

  // Paleta de colores - Modo Oscuro
  static const Color darkPrimary = Color(0xFFE040FB);                  // Violeta neón
  static const Color darkSecondary = Color(0xFF1DE9B6);                // Turquesa brillante
  static const Color darkAccent = Color(0xFFFFAB40);                   // Ámbar (Acento)

  /// Configuración del Tema Claro de la aplicación.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightSecondary,
        tertiary: lightAccent,
        surface: Color(0xFFF5F5F5),
      ),
      // Definición del sistema tipográfico (Requisito: >2 estilos visuales diferenciados)
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
        bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),
      // Estilo global y unificado para las AppBar en modo claro
      appBarTheme: const AppBarTheme(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  /// Configuración del Tema Oscuro de la aplicación.
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkSecondary,
        tertiary: darkAccent,
        surface: Color(0xFF121212),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
        bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),
      // Estilo global y unificado para las AppBar en modo oscuro
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F1F1F),
        foregroundColor: darkPrimary,
        elevation: 0,
      ),
    );
  }
}

/// ============================================================================
/// BLOQUE 1: CASCARÓN GLOBAL DE LA APP (Manejo del Estado del Tema)
/// ============================================================================
/// Widget raíz de tipo [StatefulWidget] que retiene el estado del [ThemeMode]
/// y redibuja el árbol de componentes cuando se alterna el entorno.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Estado de la aplicación: por defecto inicia en modo claro
  ThemeMode _themeMode = ThemeMode.light;

  /// Modifica el estado global alternando entre modo claro y oscuro.
  void _alternarTema() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reto 2 - Tema Personalizado',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      // Inyección de dependencias y callbacks hacia la vista del menú
      home: Menu(
        onCambiarTema: _alternarTema,
        esModoOscuro: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

/// ============================================================================
/// BLOQUE 2: VISTA PRINCIPAL (Interfaz de Usuario y Componentes)
/// ============================================================================
/// Pantalla principal que renderiza los widgets personalizados y maneja
/// los eventos de interacción locales.
class Menu extends StatefulWidget {
  final VoidCallback onCambiarTema;
  final bool esModoOscuro;

  const Menu({
    super.key,
    required this.onCambiarTema,
    required this.esModoOscuro,
  });

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> { 
  // Estado local para el widget interactivo del contador
  int _contador = 0;

  @override
  Widget build(BuildContext context) {
    // Captura del contexto dinámico del tema actual
    final temaActual = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal'),
        actions: [
          IconButton(
            // REQUISITO DE ACCESIBILIDAD: Descripción textual para lectores de pantalla
            tooltip: widget.esModoOscuro ? 'Activar modo claro' : 'Activar modo oscuro',
            onPressed: widget.onCambiarTema,
            icon: Icon(widget.esModoOscuro ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // INTERACTIVIDAD Y WIDGET PERSONALIZADO: ElevatedButton adaptativo
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: temaActual.colorScheme.primary, // Color primario dinámico
                shadowColor: temaActual.colorScheme.shadow,      // Gestión de sombras Material 3
              ),
              onPressed: () {
                setState(() {
                  _contador++; // Modificación del estado local
                });
              },
              child: Text(
                'Incrementar contador ($_contador)',
                style: temaActual.textTheme.bodyMedium?.copyWith(
                  color: temaActual.colorScheme.tertiary, // Uso del color de acento
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // WIDGET PERSONALIZADO: Card que hereda propiedades estructurales del tema
            Card(
              color: temaActual.colorScheme.secondary, // Fondo configurado con el color secundario
              elevation: 4, 
              child: Padding(
                padding: const EdgeInsets.all(16.0), 
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '¡Bienvenido al reto de Flutter!',
                      style: temaActual.textTheme.displayLarge?.copyWith(
                        color: temaActual.colorScheme.tertiary, // Título destacado con color de acento
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Este es un ejemplo de cómo estructurar una aplicación Flutter...',
                      style: temaActual.textTheme.bodyMedium?.copyWith(
                        color: temaActual.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}