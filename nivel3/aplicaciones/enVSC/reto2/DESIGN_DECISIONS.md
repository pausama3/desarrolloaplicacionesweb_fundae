# Decisiones de Diseño - Reto 2 Flutter

## 🎨 Paleta de Colores
* **Modo Claro:** Se ha optado por un Morado Profundo (`#360146`) como color primario para dar una identidad visual fuerte, combinado con un Turquesa (`Teal`) secundario para elementos estructurales (como las tarjetas) y un Naranja Brillante de acento (`tertiary`) para destacar acciones secundarias (como el texto del botón).
* **Modo Oscuro:** Se transforma hacia tonalidades neón (Violeta neón y Turquesa brillante) manteniendo la misma jerarquía pero reduciendo la fatiga visual sobre un fondo oscuro (`#121212`).

## font 📄 Tipografías y Estilos
* Se han configurado tres escalones tipográficos en el `TextTheme`:
  1. `displayLarge`: Estilo destacado, en negrita (`bold`) y con espaciado de letras expandido para títulos principales.
  2. `titleLarge`: Estilo intermedio con inclinación (`italic`) para secciones.
  3. `bodyMedium`: Fuente regular y limpia para textos de lectura corrida.

## ♿ Accesibilidad e Interactividad
* Cada elemento interactivo cuenta con `tooltips` semánticos.
* Se ha garantizado el contraste de color utilizando las propiedades `onSecondary` del `ColorScheme`, evitando textos oscuros sobre fondos oscuros.