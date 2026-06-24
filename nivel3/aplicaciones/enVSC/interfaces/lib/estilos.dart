import 'package:flutter/material.dart';

// ============================================================================
// 1. ENCAPSULACIÓN DE ESTILOS EN CLASES (Tokens de Diseño)
// ============================================================================

/// Clase abstracta que actúa como contenedor estático para los estilos base.
/// Centraliza los estilos tipográficos para mitigar la redundancia de código.
abstract class AppStyles {
  static const TextStyle tituloPrincipal = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
    fontFamily: 'monospace',
  );

  static const TextStyle cuerpoTexto = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );
}

// ============================================================================
// 2. COMBINACIÓN E HERENCIA DE ESTILOS (Polimorfismo Visual)
// ============================================================================

/// Clase encargada de demostrar la especialización o combinación de estilos
/// mediante el método de copia estructural nativo de Flutter (`copyWith`).
abstract class AppStylesEspecializados {
  static final TextStyle tituloExito = AppStyles.tituloPrincipal.copyWith(
    color: Colors.teal[700],
  );

  static final TextStyle tituloError = AppStyles.tituloPrincipal.copyWith(
    color: Colors.red[700],
  );

  static final TextStyle cuerpoDestacado = AppStyles.cuerpoTexto.copyWith(
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
}

// ============================================================================
// 3. ENFOQUE A: ESTILOS PERSONALIZADOS POR HERENCIA (Pág. 12 del PDF)
// ============================================================================

/// Clase personalizada que hereda de TextStyle mediante el mecanismo clásico.
/// Permite añadir propiedades adicionales de diseño (como un margen formal).
class MiEstiloTextoFundae extends TextStyle {
  final double margenHorizontal;

  // 🟢 CORREGIDO: Añadido 'const' para cumplir con la inmutabilidad de TextStyle
  const MiEstiloTextoFundae({
    required super.color,
    required super.fontSize,
    super.fontWeight = FontWeight.normal,
    this.margenHorizontal = 0.0,
  });
}

// ============================================================================
// 4. ENFOQUE B: EXTENSIÓN DE LA CLASE TEXTSTYLE (Pág. 13 del PDF)
// ============================================================================

/// Extensión semántica sobre la clase nativa [TextStyle]. 
/// Permite añadir métodos personalizados a clases existentes sin recurrir a la
/// herencia tradicional.
extension CustomTextStyleExtensions on TextStyle {
  TextStyle get conSubrayado => copyWith(decoration: TextDecoration.underline);
  TextStyle get enCursiva => copyWith(fontStyle: FontStyle.italic);
  TextStyle evaluarEscala(double factor) => copyWith(fontSize: (fontSize ?? 14.0) * factor);
}

// ============================================================================
// 5. COMPONENTES Y TEMAS PERSONALIZADOS AVANZADOS (ThemeExtension)
// ============================================================================

class CalculadoraThemeStyles extends ThemeExtension<CalculadoraThemeStyles> {
  final Color? colorPantallaFondo;
  final TextStyle? estiloTextoHistorial;

  const CalculadoraThemeStyles({
    required this.colorPantallaFondo,
    required this.estiloTextoHistorial,
  });

  @override
  ThemeExtension<CalculadoraThemeStyles> copyWith({
    Color? colorPantallaFondo,
    TextStyle? estiloTextoHistorial,
  }) {
    return CalculadoraThemeStyles(
      colorPantallaFondo: colorPantallaFondo ?? this.colorPantallaFondo,
      estiloTextoHistorial: estiloTextoHistorial ?? this.estiloTextoHistorial,
    );
  }

  @override
  ThemeExtension<CalculadoraThemeStyles> lerp(
    covariant ThemeExtension<CalculadoraThemeStyles>? other,
    double t,
  ) {
    if (other is! CalculadoraThemeStyles) return this;
    return CalculadoraThemeStyles(
      colorPantallaFondo: Color.lerp(colorPantallaFondo, other.colorPantallaFondo, t),
      estiloTextoHistorial: TextStyle.lerp(estiloTextoHistorial, other.estiloTextoHistorial, t),
    );
  }
}

// ============================================================================
// 6. DEFINICIÓN DE TEMAS GLOBALES DE LA APLICACIÓN
// ============================================================================

abstract class AppThemes {
  static ThemeData get temaClaro {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.light),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.indigo, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      extensions: [
        CalculadoraThemeStyles(
          colorPantallaFondo: Colors.grey[200],
          estiloTextoHistorial: const TextStyle(color: Colors.black87, fontFamily: 'monospace', fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  static ThemeData get temaOscuro {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      extensions: [
        CalculadoraThemeStyles(
          colorPantallaFondo: Colors.grey[900],
          estiloTextoHistorial:  TextStyle(color: Colors.teal[400], fontFamily: 'monospace', fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// ============================================================================
// 🛠️ MANUAL INTERACTIVO EN AISLAMIENTO (ENTORNO DE PRUEBAS COMPLETO)
// ============================================================================

void main() {
  runApp(const VentanaDePruebasApp());
}

class VentanaDePruebasApp extends StatelessWidget { // 🟢 CAMBIAR AQUÍ A StatelessWidget
  const VentanaDePruebasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Manual de Estilos',
      debugShowCheckedModeBanner: false,
      home: ControlarFocoManual(),
    );
  }
}

class ControlarFocoManual extends StatefulWidget {
  const ControlarFocoManual({super.key});

  @override
  State<ControlarFocoManual> createState() => _ControlarFocoManualState();
}

class _ControlarFocoManualState extends State<ControlarFocoManual> {
  ThemeMode _modoActual = ThemeMode.light;

  void _conmutarTema() {
    setState(() {
      _modoActual = _modoActual == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _modoActual == ThemeMode.light ? AppThemes.temaClaro : AppThemes.temaOscuro,
      child: ManualEstilosHome(
        onToggleTema: _conmutarTema,
        esOscuro: _modoActual == ThemeMode.dark,
      ),
    );
  }
}

class ManualEstilosHome extends StatelessWidget {
  final VoidCallback onToggleTema;
  final bool esOscuro;

  const ManualEstilosHome({
    super.key,
    required this.onToggleTema,
    required this.esOscuro,
  });

  @override
  Widget build(BuildContext context) {
    final estilosTema = Theme.of(context).extension<CalculadoraThemeStyles>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Libro de Estilos & Temas (FUNDAE)'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: Icon(esOscuro ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleTema,
            tooltip: 'Alternar entre Modo Claro y Oscuro',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARD 1: DESIGN TOKENS
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1. Encapsulación (Design Tokens)', style: AppStyles.tituloPrincipal),
                    const SizedBox(height: 8),
                    Text(
                      'CONCEPTO:\nConsiste en centralizar propiedades tipográficas fijas dentro de una clase abstracta como campos "static const". Esto optimiza el rendimiento cargando la constante una sola vez en la memoria RAM.',
                      style: AppStyles.cuerpoTexto,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // CARD 2: REGLA DE PRIORIDAD (Pág. 5 del PDF)
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('2. Ley de Prioridades de Estilos', style: AppStyles.tituloPrincipal),
                    const SizedBox(height: 8),
                    Text(
                      'CONCEPTO:\nSegún el documento, los estilos locales definidos directamente en el widget siempre tienen mayor prioridad que los estilos heredados del tema global de la aplicación.',
                      style: AppStyles.cuerpoTexto,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Este texto hereda el estilo del Tema Global.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Este texto pisa el tema usando un estilo local personalizado (Prioridad Máxima).',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.blue, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // CARD 3: HERENCIA POR CLASE CLÁSICA (Pág. 12 del PDF)
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('3. Herencia tradicional (extends TextStyle)', style: AppStyles.tituloPrincipal),
                    const SizedBox(height: 8),
                    Text(
                      'CONCEPTO:\nSe crea una clase de Dart que extiende explícitamente a TextStyle. Permite mapear los atributos base mediante "super()" e incorporar propiedades únicas, como márgenes.',
                      style: AppStyles.cuerpoTexto,
                    ),
                    const SizedBox(height: 12),
                    // 🟢 CORREGIDO: Eliminada la asignación ilegal '=' al campo final
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Texto renderizado con: MiEstiloTextoFundae()',
                        style: MiEstiloTextoFundae(
                          color: Colors.purple,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          margenHorizontal: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // CARD 4: EXTENSIONS
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('4. Extensiones de Clase (Pág. 13)', style: AppStyles.tituloPrincipal),
                    const SizedBox(height: 8),
                    Text(
                      'CONCEPTO:\nPermite añadir comportamiento a clases nativas (como TextStyle) desde fuera, salteándose los límites de la herencia tradicional. Facilita una sintaxis encadenada fluida.',
                      style: AppStyles.cuerpoTexto,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Texto modificado dinámicamente combinando extensiones.',
                      style: AppStyles.cuerpoTexto.enCursiva.conSubrayado.evaluarEscala(1.1),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // CARD 5: THEME EXTENSION
            Card(
              elevation: 4,
              color: estilosTema?.colorPantallaFondo,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('5. ThemeExtension (Material 3)', style: AppStyles.tituloPrincipal.copyWith(color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(height: 8),
                    Text(
                      'CONCEPTO:\nEs la estrategia recomendada en Flutter para extender la paleta global de ThemeData. Permite crear propiedades de estilo no estandarizadas y desacoplar la vista de los colores hardcodeados.',
                      style: AppStyles.cuerpoTexto.copyWith(color: esOscuro ? Colors.white70 : Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      // 🟢 CORREGIDO: Reemplazado Colors.black24 por Colors.black26
                      color: esOscuro ? Colors.black26 : Colors.white,
                      child: Text(
                        'Texto del historial usando el estilo de la ThemeExtension activa.',
                        style: estilosTema?.estiloTextoHistorial,
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