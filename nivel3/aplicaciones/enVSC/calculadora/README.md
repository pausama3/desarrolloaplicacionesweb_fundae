# calculadora
# Dojo Samurái - Calculadora Aritmética Avanzada

Una aplicación de calculadora interactiva desarrollada con **Flutter** que combina un panel de botones táctiles con un sistema avanzado de captura de eventos para teclado físico. El proyecto ha sido diseñado bajo principios de modularidad, accesibilidad universal y control defensivo de excepciones.

---

## 🚀 Características Principales

* **Procesamiento por Jerarquía Matemática:** Motor aritmético propio que procesa expresiones complejas en cascada mediante listas dinámicas (`List`), respetando estrictamente el orden de los operadores (primero divisiones/multiplicaciones, luego sumas/restas).
* **Interactividad Híbrida mediante TextField:** Incorporación de un componente `TextField` controlado por un `FocusNode` adaptado. Permite la introducción de datos mediante clics en la interfaz o a través del teclado físico del ordenador.
* **Filtro Defensivo de Entradas:** El sistema intercepta las pulsaciones del teclado en tiempo real. Si se detecta un carácter inválido (letras o símbolos no aritméticos), se bloquea la entrada y se despliega un mensaje de error controlado.
* **Historial Dinámico de Operaciones:** Almacenamiento e inserción de las transacciones matemáticas en un componente `ListView.builder` con scroll independiente, mostrando los últimos resultados en la parte superior.
* **Temas Visuales (Claro y Oscuro):** Arquitectura basada en `StatefulWidget` que permite conmutar el entorno estético global de la aplicación (`ThemeMode`) mediante un solo control en el menú.
* **Accesibilidad Universal (♿):** Inyección de componentes `Tooltip` en todos los elementos operativos de la interfaz, facilitando la lectura de pantalla para herramientas de asistencia (TalkBack/NVDA).
* **Robustez y Resiliencia (Try-Catch):** Implementación de una red de seguridad global para capturar errores de desbordamiento sintáctico o divisiones por cero indeterminadas, evitando el colapso (*crash*) de la aplicación.

---

## 📦 Requisitos Previos

Antes de proceder con la instalación, asegúrese de contar con el entorno de desarrollo configurado:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (Versión 3.x o superior).
* [Dart SDK](https://dart.dev/get-started/sdk) integrado.
* Herramientas de compilación nativas (en Linux: `build-essential`, `libgtk-3-dev`).

---

## 🛠️ Instalación y Ejecución

Siga estos pasos en la terminal de su sistema operativo para clonar y ejecutar el proyecto localmente:

### 1. Clonar el repositorio e instalar dependencias
```bash
# Clonar el proyecto
git clone [https://github.com/tu-usuario/desarrolloaplicacionesweb_fundae.git](https://github.com/tu-usuario/desarrolloaplicacionesweb_fundae.git)

# Acceder al directorio raíz
cd calculadora

# Descargar y sincronizar los paquetes de Flutter
flutter pub get