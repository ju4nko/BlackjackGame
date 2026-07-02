//
//  Card.swift
//  BlackjackGame
//
//  Created by Juanjo on 02/07/2026.
//
import Foundation
import SwiftUI

enum Palo: CaseIterable {
    case corazones
    case diamantes
    case treboles
    case picas
    
    var simbolo: String {
        switch self {
        case .corazones: return "♥"
        case .diamantes: return "♦"
        case .treboles: return "♣"
        case .picas: return "♠"
        }
    }
    
    var color: Color {
        switch self {
        case .corazones, .diamantes: return Color.red
        case .treboles, .picas: return Color.black
        }
    }
}

enum Valor: CaseIterable {
    case AS
    case K
    case Q
    case J
    case diez
    case nueve
    case ocho
    case siete
    case seis
    case cinco
    case cuatro
    case tres
    case dos
    
    var value: Int {
        switch self {
        case .AS: return 11
        case .diez,.K, .Q, .J: return 10
        case .nueve: return 9
        case .ocho: return 8
        case .siete: return 7
        case .seis: return 6
        case .cinco: return 5
        case .cuatro: return 4
        case .tres: return 3
        case .dos: return 2
        }
    }
    
    var etiqueta: String {
        switch self {
        case .AS: return "A"
        case .K: return "K"
        case .Q: return "Q"
        case .J: return "J"
        case .diez: return "10"
        case .nueve: return "9"
        case .ocho: return "8"
        case .siete: return "7"
        case .seis: return "6"
        case .cinco: return "5"
        case .cuatro: return "4"
        case .tres: return "3"
        case .dos: return "2"
        }
    }
}

struct Card: Identifiable {
    var id = UUID()
    let palo: Palo
    let valor: Valor
}


