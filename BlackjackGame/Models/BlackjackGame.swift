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
    var saldo: Int = 100 {
        didSet {
            UserDefaults.standard.set(saldo, forKey: "saldo")
        }
    }
    var apuesta: Int = 0
    
    var resultado: Resultado? {
        if state != .finished { return nil }
        if playerHand.isBust { return .ganaCrupier }
        if dealerHand.isBust { return .ganaJugador }
        if playerHand.isBlackjack && !dealerHand.isBlackjack { return .blackjackJugador }
        if playerHand.total > dealerHand.total { return .ganaJugador }
        else if dealerHand.total > playerHand.total { return .ganaCrupier}
        else { return .empate }
    }
    
    var seguro: Int = 0
    
    var sinSaldo: Bool {
        saldo < 10
    }
    
    init() {
        saldo = UserDefaults.standard.object(forKey: "saldo") as? Int ?? 100
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
        baraja = Deck()
        baraja.shuffle()
        playerHand = Hand()
        dealerHand = Hand()
        repartir(a: &playerHand)
        repartir(a: &dealerHand)
        repartir(a: &playerHand)
        repartir(a: &dealerHand)
        if dealerHand.cards.first?.valor == .AS {
            state = .seguro
            return
        }
        state = .playerTurn
        revelarBlackjackInicial()
    }
    
    func revelarBlackjackInicial() {
        if dealerHand.isBlackjack {
            terminar()
        } else if playerHand.isBlackjack {
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
        case .blackjackJugador: saldo += apuesta * 5 / 2
        case .ganaJugador: saldo += apuesta * 2
        case .ganaCrupier: break
        case .empate: saldo += apuesta
        case .none: break
        }
    }
    
    func reproducirSonido() {
        switch resultado {
        case .ganaJugador, .blackjackJugador: Sonido.reproducir(Sonido.ganar)
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
        seguro = 0
        state = .betting
    }
    
    func doblar() {
        saldo -= apuesta
        apuesta += apuesta
        repartir(a: &playerHand)
        plantarse()
    }
    
    func reiniciar() {
        saldo = 100
        apuesta = 0
        seguro = 0
        baraja = Deck()
        playerHand = Hand()
        dealerHand = Hand()
        state = .betting
    }
    
    func decidirSeguro(comprar: Bool) {
        if comprar {
            seguro = apuesta / 2
            saldo -= seguro
            if dealerHand.isBlackjack && seguro > 0 {
                saldo += seguro * 3
            }
        }
        state = .playerTurn
        revelarBlackjackInicial()
    }
    
}

enum GameState {
    case betting
    case playerTurn
    case dealerTurn
    case finished
    case seguro
}

enum Resultado {
    case blackjackJugador
    case ganaJugador
    case ganaCrupier
    case empate
}
