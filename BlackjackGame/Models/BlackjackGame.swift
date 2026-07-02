//
//  BlackjackGame.swift
//  BlackjackGame
//
//  Created by Juanjo on 02/07/2026.
//

import Foundation

@Observable
class BlackjackGame {
    var baraja: Deck
    var playerHand: Hand
    var dealerHand: Hand
    var state: GameState
    
    var resultado: Resultado? {
        if state != .finished { return nil }
        if playerHand.isBust { return .ganaCrupier }
        if dealerHand.isBust { return .ganaJugador }
        if playerHand.total > dealerHand.total { return .ganaJugador }
        else if dealerHand.total > playerHand.total { return .ganaCrupier}
        else { return .empate }
    }
    
    init() {
        baraja = Deck()
        playerHand = Hand()
        dealerHand = Hand()
        state = .playerTurn
    }
    
    func repartir(a: inout Hand) {
        if let carta = baraja.draw() { a.add(carta) }
    }
    
    func nuevaPartida() {
        baraja.shuffle()
        playerHand = Hand()
        dealerHand = Hand()
        repartir(a: &playerHand)
        repartir(a: &dealerHand)
        repartir(a: &playerHand)
        repartir(a: &dealerHand)
        state = .playerTurn
        if dealerHand.isBlackjack {
            state = .finished
        }
        if playerHand.isBlackjack {
            plantarse()
        }
        
    }
    
    func pedirCarta() {
        repartir(a: &playerHand)
        if playerHand.isBust {
            state = .finished
        }
        if playerHand.total == 21 {
            plantarse()
        }
    }
    
    func plantarse() {
        state = .dealerTurn
        while dealerHand.total < 17 {
            repartir(a: &dealerHand)
        }
        state = .finished
    }
    
}

enum GameState {
    case playerTurn
    case dealerTurn
    case finished
}

enum Resultado {
    case ganaJugador
    case ganaCrupier
    case empate
}
