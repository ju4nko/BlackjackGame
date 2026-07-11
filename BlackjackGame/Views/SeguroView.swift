//
//  SeguroView.swift
//  BlackjackGame
//
//  Created by Juanjo on 11/07/2026.
//

import SwiftUI

struct SeguroView: View {
    let juego: BlackjackGame
    
    var body: some View {
        VStack() {
            Text("El crupier muestra un As. ¿Quieres seguro?")
            HStack {
                Button("Sí") {
                    Task { await   juego.decidirSeguro(comprar: true) }
                }.disabled(juego.saldo < juego.apuesta / 2)
                Button("No") {
                    Task { await juego.decidirSeguro(comprar: false) }
                }
            }
            .disabled(juego.repartiendo)
        }
    }
}

#Preview {
    SeguroView(juego: BlackjackGame())
}
