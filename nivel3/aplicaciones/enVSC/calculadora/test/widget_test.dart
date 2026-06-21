
import 'package:flutter_test/flutter_test.dart';
import 'package:calculadora/main.dart'; // Asegúrate de que este import coincide con tu proyecto

void main() {
  testWidgets('Prueba de navegación del Dojo Samurái', (WidgetTester tester) async {
    // 1. Montamos la aplicación en el simulador de tests
    await tester.pumpWidget(const CalculadoraApp());

    // 2. Verificamos que arranca en el Menú Principal correctamente
    expect(find.text('¡Bienvenido!'), findsOneWidget);
    expect(find.text('Abrir Calculadora'), findsOneWidget);

    // 3. Simulamos un toque (tap) en el botón para abrir la calculadora
    await tester.tap(find.text('Abrir Calculadora'));
    
    // 4. Reconstruimos el frame de la app para que procese la animación de viaje (Navigator)
    await tester.pumpAndSettle();

    // 5. Verificamos que ya estamos dentro de la calculadora básica
    expect(find.text('Calculadora Básica'), findsOneWidget);
    expect(find.text('0'), findsNWidgets(2)); // Comprueba que la pantalla de la calculadora arranca en 0
  });
}