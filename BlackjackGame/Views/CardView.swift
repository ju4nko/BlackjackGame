//
//  CardView.swift
//  BlackjackGame
//
//  Created by Juanjo on 02/07/2026.
//

import SwiftUI

struct CardView: View {
    let card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8).stroke(.gray, lineWidth: 1)
                        
                )
            Text("\(card.valor.etiqueta)\(card.palo.simbolo)")
                .foregroundStyle(card.palo.color)
        }
        .shadow(radius: 3)
        .frame(width: 60, height: 90)
    }
}

#Preview {
    CardView(card: Card(palo: .corazones, valor: .AS))
}
