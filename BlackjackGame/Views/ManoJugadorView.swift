//
//  ManoJugadorView.swift
//  BlackjackGame
//
//  Created by Juanjo on 10/07/2026.
//

import SwiftUI

struct ManoJugadorView: View {
    let mano: Hand
    let resultado: Resultado?
    let atenuada: Bool
    
    var body: some View {
        VStack {
            Text("Jugador: \(mano.total)" + (mano.total == 21 ? " ✨" : ""))
            if let resultadoMano = resultado {
                Text(resultadoMano.mensaje)
            }
            HStack {
                ForEach(mano.cards) { card in
                    CardView(card: card)
                }
            }
            
        }
        .opacity(!atenuada ? 1 : 0.4)
    }
    
}



#Preview {
    ManoJugadorView(mano: mano([.AS, .K]), resultado: .ganaJugador, atenuada: false)
}

private func mano(_ valores: [Valor]) -> Hand {
    var h = Hand()
    for v in valores { h.add(Card(palo:.picas, valor: v)) }
    return h
}
