//
//  BotonesApuestaView.swift
//  BlackjackGame
//
//  Created by Juanjo on 11/07/2026.
//

import SwiftUI

struct BotonesApuestaView: View {
    let juego: BlackjackGame
    
    var body: some View {
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
                Button { 
                    juego.añadirApuesta(10)
                } label: {
                    FichaView(valor: 10)
                }
                .disabled(juego.apuesta + 10 > juego.saldo)
                Button {
                    juego.añadirApuesta(25)
                } label: {
                    FichaView(valor: 25)
                }.disabled(juego.apuesta + 25 > juego.saldo)
                Button {
                    juego.añadirApuesta(50)
                } label: {
                    FichaView(valor: 50)
                 }.disabled(juego.apuesta + 50 > juego.saldo)
            }
            .buttonStyle(.plain)
            Button("Apostar") {
                Task { await juego.apostar(juego.apuesta) }
            }.disabled(juego.apuesta == 0)
        }
    }
}

#Preview {
    BotonesApuestaView(juego: BlackjackGame())
}
