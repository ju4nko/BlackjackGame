//
//  Hand.swift
//  BlackjackGame
//
//  Created by Juanjo on 02/07/2026.
//

struct Hand {
    var cards: [Card] = []
    
    mutating func add(_ card: Card) {
        cards.append(card)
    }
    
    var total: Int {
        // 1. sumar todos los .valor.value
        var suma = 0
        var ases = 0
        for card in cards {
            suma += card.valor.value // Sumamos el valor de la carta
            if card.valor == .AS { // Contamos cuantos Ases tenemos en la mano
                ases += 1
            }
        }
        while suma > 21 && ases > 0 {
            suma -= 10
            ases -= 1
        }
        return suma
    }
    
    var isBust: Bool {
        total > 21
    }
    
    var isBlackjack: Bool {
        total == 21 && cards.count == 2
    }
}
