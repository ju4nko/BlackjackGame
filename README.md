# 🃏 Blackjack

Un juego de **Blackjack (21)** para iOS, hecho en **SwiftUI**. Juega contra el crupier: pide cartas, plántate y trata de acercarte a 21 sin pasarte.

Proyecto desarrollado paso a paso como ejercicio de aprendizaje de Swift y SwiftUI, con especial cuidado en separar la **lógica del juego** de la **interfaz**.

## ✨ Características

- Baraja completa de 52 cartas, barajada aleatoriamente en cada partida.
- Cálculo de puntuación con **As flexible** (vale 1 u 11, lo que más convenga).
- Detección de **bust** (pasarse de 21) y **blackjack natural** (21 con dos cartas).
- IA del crupier con la regla estándar de casino: pide cartas hasta llegar a 17.
- Determinación automática del ganador (jugador, crupier o empate).
- Interfaz reactiva con SwiftUI: las cartas y los totales se actualizan solos.
- Cartas dibujadas con su símbolo (♥ ♦ ♣ ♠) y color correspondiente.

## 🎮 Cómo se juega

1. Pulsa **Nueva Partida** para repartir.
2. **Pedir** para robar otra carta, o **Plantarse** para pasar el turno al crupier.
3. Si te pasas de 21, pierdes. Si no, el crupier juega y se compara quién se acerca más a 21.

## 🏗️ Arquitectura

El proyecto separa claramente el modelo de datos de la vista:

| Archivo | Responsabilidad |
|---------|-----------------|
| `Models/Card.swift` | La carta: palo, valor, puntuación y representación visual |
| `Models/Deck.swift` | La baraja: generar 52 cartas, barajar y repartir |
| `Models/Hand.swift` | Una mano: total con As flexible, detección de bust y blackjack |
| `Models/BlackjackGame.swift` | El motor del juego: reparto, turnos, IA del crupier y resultado |
| `Views/CardView.swift` | Vista de una carta individual |
| `Views/ContentView.swift` | Pantalla principal del juego |

Toda la lógica vive en el modelo y es independiente de la interfaz, lo que permite probarla y reutilizarla con cualquier UI.

## 🛠️ Tecnologías

- **Swift**
- **SwiftUI**
- **`@Observable`** (Observation framework) para el estado reactivo

## 🚀 Cómo ejecutar

1. Clona el repositorio:
   ```bash
   git clone <url-del-repositorio>
   ```
2. Abre `BlackjackGame.xcodeproj` en Xcode.
3. Selecciona un simulador de iPhone y pulsa **Run** (⌘R).

## 📋 Requisitos

- Xcode 16 o superior
- iOS 17 o superior (por el uso de `@Observable`)

## 🗺️ Próximas mejoras

- [x] Ocultar la carta oculta del crupier durante el turno del jugador
- [x] Diseño del reverso de las cartas (carta boca abajo)
- [ ] Sistema de fichas y apuestas
- [ ] Animaciones al repartir cartas
- [ ] Sonidos
- [ ] Tests unitarios con el framework Testing
