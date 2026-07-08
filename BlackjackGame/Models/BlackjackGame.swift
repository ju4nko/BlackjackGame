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
    var manosJugador: [Hand] = [Hand()]
    var manoActiva: Int = 0
    var dealerHand: Hand
    var state: GameState
    var saldo: Int = 100 {
        didSet {
            UserDefaults.standard.set(saldo, forKey: "saldo")
        }
    }
    var apuestaTotal: Int {
        apuesta * manosJugador.count
    }
    var apuesta: Int = 0
    
    var resultado: Resultado? {
        resultado(de: manosJugador[manoActiva])
    }
    
    var seguro: Int = 0
    
    var sinSaldo: Bool {
        saldo < 10
    }
    
    var puedeDividir: Bool {
        manosJugador[manoActiva].cards.count == 2 && manosJugador[manoActiva].cards.first?.valor.value == manosJugador[manoActiva].cards.last?.valor.value && saldo >= apuesta && manosJugador.count == 1
    }
    
    init() {
        saldo = UserDefaults.standard.object(forKey: "saldo") as? Int ?? 100
        baraja = Deck()
        manosJugador = [Hand()]
        manoActiva = 0
        dealerHand = Hand()
        state = .betting
    }
    
    
    func resultado(de mano: Hand) -> Resultado? {
        if state != .finished { return nil }
        if mano.isBust { return .ganaCrupier }
        if mano.isBlackjack && !dealerHand.isBlackjack && manosJugador.count == 1 { return .blackjackJugador }
        if dealerHand.isBust { return .ganaJugador }
        if mano.total > dealerHand.total { return .ganaJugador }
        else if dealerHand.total > mano.total { return .ganaCrupier}
        else { return .empate }
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
        manosJugador = [Hand()]
        manoActiva = 0
        dealerHand = Hand()
        repartir(a: &manosJugador[manoActiva])
        repartir(a: &dealerHand)
        repartir(a: &manosJugador[manoActiva])
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
        } else if manosJugador[manoActiva].isBlackjack {
            plantarse()
        }
    }
    
    func pedirCarta() {
        repartir(a: &manosJugador[manoActiva])
        if (manosJugador[manoActiva].isBust || manosJugador[manoActiva].total == 21) {
            avanzarMano()
        }
    }
    
    func plantarse() {
        avanzarMano()
    }
    
    func avanzarMano() {
        if manoActiva + 1 < manosJugador.count {
            manoActiva += 1
        } else {
            turnoCrupier()
        }
    }
    
    func turnoCrupier() {
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
        for mano in manosJugador {
            switch resultado(de: mano) {
            case .blackjackJugador: saldo += apuesta * 5 / 2
            case .ganaJugador: saldo += apuesta * 2
            case .ganaCrupier: break
            case .empate: saldo += apuesta
            case .none: break
            }
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
        repartir(a: &manosJugador[manoActiva])
        plantarse()
    }
    
    func reiniciar() {
        saldo = 100
        apuesta = 0
        seguro = 0
        baraja = Deck()
        manosJugador = [Hand()]
        manoActiva = 0
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
    
    func dividir() {
        saldo -= apuesta
        let cartaUno = manosJugador[manoActiva].cards[0]
        let cartaDos = manosJugador[manoActiva].cards[1]
        var manoUno = Hand()
        var manoDos = Hand()
        manoUno.add(cartaUno)
        manoDos.add(cartaDos)
        manosJugador = [manoUno, manoDos]
        repartir(a: &manosJugador[0])
        repartir(a: &manosJugador[1])
        manoActiva = 0
        state = .playerTurn
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

extension Resultado {
    var mensaje: String {
        switch self {
        case .blackjackJugador: return "¡Blackjack! 🎉"
        case .ganaJugador: return "¡Has ganado!"
        case .ganaCrupier: return "Gana el crupier"
        case .empate: return "¡Empate!"
        }
    }
}
