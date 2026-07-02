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
            if let resultado = juego.resultado {
                switch resultado {
                case .ganaJugador: Text("¡Has ganado!")
                case .ganaCrupier: Text("Gana el crupier")
                case .empate: Text("¡Empate!")
                }
            }
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
            Button("Nueva Partida") {
                juego.nuevaPartida()
            }
            HStack {
                Button("Pedir") {
                    juego.pedirCarta()
                }
                .disabled(juego.state != .playerTurn)
                Button("Plantarse") {
                    juego.plantarse()
                }
                .disabled(juego.state != .playerTurn)
            }
            
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
