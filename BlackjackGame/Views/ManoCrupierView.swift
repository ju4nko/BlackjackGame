//
//  ManoCrupierView.swift
//  BlackjackGame
//
//  Created by Juanjo on 11/07/2026.
//

import SwiftUI

struct ManoCrupierView: View {
    let mano: Hand
    let ocultarSegunda: Bool
    
    var textoCrupier: String {
        if ocultarSegunda {
            if let primera = mano.cards.first {
                return "\(primera.valor.value)"
            } else {
                return "0"
            }
        } else {
            return "\(mano.total)"
        }
    }
    
    var body: some View {
        VStack {
            Text("Crupier: \(textoCrupier)")
            HStack {
                ForEach(Array(mano.cards.enumerated()), id: \.element.id) { indice, card in
                    CardView(card: card, isFaceDown: indice == 1 && ocultarSegunda)
                }
                .animation(.easeOut(duration: 0.3), value: mano.cards.count)
                
            }
        }
    }
}

#Preview {
    VStack {
        ManoCrupierView(mano: mano([.AS, .K]), ocultarSegunda: true)
        ManoCrupierView(mano: mano([.Q, .cinco]), ocultarSegunda: false)
    }
}

private func mano(_ valores: [Valor]) -> Hand {
    var h = Hand()
    for v in valores { h.add(Card(palo:.picas, valor: v)) }
    return h
}


