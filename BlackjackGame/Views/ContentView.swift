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
                ManoCrupierView(mano: juego.dealerHand, ocultarSegunda: juego.state == .playerTurn || juego.state == .seguro)
                    .animation(.easeOut(duration: 0.3), value: juego.dealerHand.cards.count)
                ForEach(juego.manosJugador.indices, id: \.self) { indice in
                    ManoJugadorView(mano: juego.manosJugador[indice],
                                    resultado: juego.resultado(de: juego.manosJugador[indice]),
                                    atenuada: !(indice == juego.manoActiva || juego.state != .playerTurn))
                }
                
            } else {
                Text("Elija su apuesta")
            }
            switch juego.state {
            case .betting: BotonesApuestaView(juego: juego)
            case .playerTurn: BotonesJugadorView(juego: juego)
            case .dealerTurn: EmptyView()
            case .finished: Button("Nueva ronda") { juego.nuevaRonda() }
            case .seguro: SeguroView(juego: juego)
            }
            Spacer()
            VStack {
                Text("Apuesta total: \(juego.apuestaTotal)€")
                Text("Saldo: \(juego.saldo)€")
            }
            .padding()
            .glassEffect()
            
        }
        
        .buttonStyle(.glass)
        .padding()
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .background(
            RadialGradient(
                colors: [Color(red: 0.1, green: 0.45, blue: 0.2),   // centro iluminado
                         Color(red: 0.02, green: 0.25, blue: 0.1)], // bordes en sombra
                center: .center,
                startRadius: 50,
                endRadius: 500
            )
            .ignoresSafeArea()
        )
    }
    
    
}
#Preview {
    ContentView()
}
