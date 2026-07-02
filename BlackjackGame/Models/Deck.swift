//
//  Deck.swift
//  BlackjackGame
//
//  Created by Juanjo on 02/07/2026.
//
struct Deck {
    var cards: [Card] = []
    
    init() {
        for palo in Palo.allCases {
            for valor in Valor.allCases {
                cards.append(Card(palo: palo, valor: valor))
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    // Repartir carta
    mutating func draw() -> Card? {
        return cards.popLast()
    }
}
