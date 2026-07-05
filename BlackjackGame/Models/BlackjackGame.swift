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
    var saldo: Int = 100
    var apuesta: Int = 0
    
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
        state = .betting
    }
    
    func repartir(a: inout Hand) {
        if let carta = baraja.draw() {
            a.add(carta)
            Sonido.reproducir(Sonido.carta)
        }
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
            terminar()
        }
        if playerHand.isBlackjack {
            plantarse()
        }
        
    }
    
    func pedirCarta() {
        repartir(a: &playerHand)
        if playerHand.isBust {
            terminar()
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
        terminar()
    }
    

    func apostar(_ cantidad: Int) {
        saldo -= cantidad     // descuento único aquí
        nuevaPartida()
    }
    
    func añadirApuesta(_ cantidad: Int) {
       apuesta += cantidad
    }
    
    func resolver() {
        switch resultado {
        case .ganaJugador: saldo += apuesta * 2
        case .ganaCrupier: break
        case .empate: saldo += apuesta
        case .none: break
        }
    }
    
    func reproducirSonido() {
        switch resultado {
        case .ganaJugador: Sonido.reproducir(Sonido.ganar)
        case .ganaCrupier: Sonido.reproducir(Sonido.perder)
        case .empate, .none: break
        }
    }
    
    func terminar() {
        state = .finished
        resolver()
        reproducirSonido()
        
    }
    
    func nuevaRonda() {
        apuesta = 0
        state = .betting
    }
    
}

enum GameState {
    case betting
    case playerTurn
    case dealerTurn
    case finished
}

enum Resultado {
    case ganaJugador
    case ganaCrupier
    case empate
}
