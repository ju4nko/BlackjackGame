//
//  CardView.swift
//  BlackjackGame
//
//  Created by Juanjo on 02/07/2026.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var isFaceDown: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(isFaceDown ? .blue : .white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8).stroke(.gray, lineWidth: 1)
                    
                )
            if !isFaceDown {
                Text("\(card.valor.etiqueta)\(card.palo.simbolo)")
                    .foregroundStyle(card.palo.color)
            }
            
        }
        .shadow(radius: 3)
        .frame(width: 60, height: 90)
        .rotation3DEffect(.degrees(isFaceDown ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .animation(.default, value: isFaceDown)
        .transition(.scale.combined(with: .opacity))
    }
    
}

#Preview {
    CardView(card: Card(palo: .corazones, valor: .AS))
}
