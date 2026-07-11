//
//  BotonesJugadorView.swift
//  BlackjackGame
//
//  Created by Juanjo on 11/07/2026.
//

import SwiftUI

struct BotonesJugadorView: View {
    let juego: BlackjackGame
    
    var body: some View {
        HStack {
            Button("Pedir") {
                Task { await juego.pedirCarta() }
            }
            Button("Plantarse") {
                Task { await juego.plantarse()}
                
            }
            Button("Doblar") {
                Task { await juego.doblar() }
                
            }.disabled(juego.manosJugador.count > 1 || juego.manosJugador[juego.manoActiva].cards.count != 2 || juego.saldo < juego.apuesta)
            
            Button("Dividir") {
                Task { await juego.dividir() }
                
            }.disabled(!juego.puedeDividir)
        }
        .disabled(juego.repartiendo)
    }
}

#Preview {
    BotonesJugadorView(juego: BlackjackGame())
}
