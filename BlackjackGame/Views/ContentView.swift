//
//  ContentView.swift
//  BlackjackGame
//
//  Created by Juanjo on 02/07/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var juego = BlackjackGame()
    
    var body: some View {
        VStack {
            Spacer()
            if let resultado = juego.resultado {
                switch resultado {
                case .blackjackJugador: Text("¡Blackjack! 🎉")
                case .ganaJugador: Text("¡Has ganado!")
                case .ganaCrupier: Text("Gana el crupier")
                case .empate: Text("¡Empate!")
                }
            }
            if juego.state != .betting {
                Text("Crupier: \(textoCrupier)")
                
                HStack {
                    ForEach(Array(juego.dealerHand.cards.enumerated()), id: \.element.id) { indice, card in
                        CardView(card: card, isFaceDown: indice == 1 && juego.state == .playerTurn)
                    }
                }
                Text("Jugador: \(juego.playerHand.total)")
                HStack {
                    ForEach(juego.playerHand.cards) { card in
                        CardView(card: card)
                    }
                }
            } else {
                Text("Elija su apuesta")
            }
            switch juego.state {
            case .betting:
                // Botones de apuesta
                HStack {
                    Button("10€") { juego.añadirApuesta(10) }.disabled(juego.apuesta + 10 > juego.saldo)
                    Button("25€") { juego.añadirApuesta(25) }.disabled(juego.apuesta + 25 > juego.saldo)
                    Button("50€") { juego.añadirApuesta(50) }.disabled(juego.apuesta + 50 > juego.saldo)
                }
                Button("Apostar") {
                    withAnimation {
                        juego.apostar(juego.apuesta)
                    }
                }
            case .playerTurn:
                HStack {
                    Button("Pedir") {
                        withAnimation {
                            juego.pedirCarta()
                        }
                    }
                    Button("Plantarse") {
                        withAnimation {
                            juego.plantarse()
                        }
                    }
                }
            case .dealerTurn:
                EmptyView()
                
            case .finished:
                Button("Nueva ronda") { juego.nuevaRonda() }
            }
            
            Spacer()
            Text("Apuesta total: \(juego.apuesta)€")
            Text("Saldo: \(juego.saldo)€")
        }
        .padding()
    }
    
    var textoCrupier: String {
        if juego.state == .playerTurn {
            if let primera = juego.dealerHand.cards.first {
                return "\(primera.valor.value)"
            } else {
                return "0"
            }
        } else {
            return "\(juego.dealerHand.total)"
        }
    }
}



#Preview {
    ContentView()
}
