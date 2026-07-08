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
            if juego.state != .betting {
                Text("Crupier: \(textoCrupier)")
                
                HStack {
                    ForEach(Array(juego.dealerHand.cards.enumerated()), id: \.element.id) { indice, card in
                        CardView(card: card, isFaceDown: indice == 1 && (juego.state == .playerTurn || juego.state == .seguro))
                    }
                }
                ForEach(juego.manosJugador.indices, id: \.self) { indice in
                    VStack {
                        Text("Jugador: \(juego.manosJugador[indice].total)")
                        if let resultadoMano = juego.resultado(de: juego.manosJugador[indice]) {
                            Text(resultadoMano.mensaje)
                        }
                        HStack {
                            ForEach(juego.manosJugador[indice].cards) { card in
                                CardView(card: card)
                            }
                        }
                    }
                    .opacity(indice == juego.manoActiva || juego.state != .playerTurn ? 1 : 0.4)
                }
                
            } else {
                Text("Elija su apuesta")
            }
            switch juego.state {
            case .betting:
                // Botones de apuesta
                if juego.sinSaldo {
                    VStack() {
                        Text("Te has quedado sin dinero 💸")
                        Button("Empezar de nuevo") {
                            juego.reiniciar()
                        }
                    }
                } else {
                    HStack {
                        Button("10€") { juego.añadirApuesta(10) }.disabled(juego.apuesta + 10 > juego.saldo)
                        Button("25€") { juego.añadirApuesta(25) }.disabled(juego.apuesta + 25 > juego.saldo)
                        Button("50€") { juego.añadirApuesta(50) }.disabled(juego.apuesta + 50 > juego.saldo)
                    }
                    Button("Apostar") {
                        withAnimation { juego.apostar(juego.apuesta) }
                    }.disabled(juego.apuesta == 0)
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
                    Button("Doblar") {
                        withAnimation {
                            juego.doblar()
                        }
                    }.disabled(juego.manosJugador.count > 1 || juego.manosJugador[juego.manoActiva].cards.count != 2 || juego.saldo < juego.apuesta)
                    
                    Button("Dividir") {
                        withAnimation {
                            juego.dividir()
                        }
                        
                    }.disabled(!juego.puedeDividir)
                }
            case .dealerTurn:
                EmptyView()
                
            case .finished:
                Button("Nueva ronda") { juego.nuevaRonda() }
                
            case .seguro:
                VStack() {
                    Text("El crupier muestra un As. ¿Quieres seguro?")
                    HStack {
                        Button("Sí") {
                            juego.decidirSeguro(comprar: true)
                        }.disabled(juego.saldo < juego.apuesta / 2)
                        Button("No") {
                            juego.decidirSeguro(comprar: false)
                        }
                    }
                    
                }
                
            }
            
            Spacer()
            Text("Apuesta total: \(juego.apuestaTotal)€")
            Text("Saldo: \(juego.saldo)€")
        }
        .padding()
    }
    
    var textoCrupier: String {
        if juego.state == .playerTurn || juego.state == .seguro {
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
