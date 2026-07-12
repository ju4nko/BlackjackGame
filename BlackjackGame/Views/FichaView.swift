//
//  FichaView.swift
//  BlackjackGame
//
//  Created by Juanjo on 11/07/2026.
//

import SwiftUI

struct FichaView: View {
    let valor: Int
    
    var colorFicha: Color  {
        switch valor {
        case 10:  return .red
        case 25: return .purple
        case 50: return .blue
        default: return .black
        }
    }
    var body: some View {
        ZStack {
            Circle().fill(colorFicha)
            Circle()
                .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: [8]))  // el anillo discontinuo
                .foregroundStyle(.white)
                .padding(4)
            Text("\(valor)€")
                .foregroundStyle(.white)// en negrita y blanco
        }
        .frame(width: 60, height: 60)
    }
}

#Preview {
    FichaView(valor: 25)
}
