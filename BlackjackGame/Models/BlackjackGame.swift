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
    var repartiendo = false
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
    
    func nuevaPartida() async {
        repartiendo = true
        defer { repartiendo = false}
        baraja = Deck()
        baraja.shuffle()
        manosJugador = [Hand()]
        manoActiva = 0
        dealerHand = Hand()
        state = .playerTurn
        try? await Task.sleep(for: .milliseconds(350))
        repartir(a: &manosJugador[manoActiva])
        try? await Task.sleep(for: .milliseconds(350))
        repartir(a: &dealerHand)
        try? await Task.sleep(for: .milliseconds(350))
        repartir(a: &manosJugador[manoActiva])
        try? await Task.sleep(for: .milliseconds(350))
        repartir(a: &dealerHand)
        try? await Task.sleep(for: .milliseconds(350))
        if dealerHand.cards.first?.valor == .AS {
            state = .seguro
            return
        }
        await revelarBlackjackInicial()
    }
    
    func revelarBlackjackInicial() async {
        if dealerHand.isBlackjack {
            terminar()
        } else if manosJugador[manoActiva].isBlackjack {
            await plantarse()
        }
    }
    
    func pedirCarta() async {
        repartiendo = true
        try? await Task.sleep(for: .milliseconds(350))
        repartir(a: &manosJugador[manoActiva])
        if (manosJugador[manoActiva].isBust || manosJugador[manoActiva].total == 21) {
            await avanzarMano()
        }
        repartiendo = false
    }
    
    func plantarse() async {
        await avanzarMano()
    }
    
    func avanzarMano() async {
        if manoActiva + 1 < manosJugador.count {
            manoActiva += 1
        } else {
            await turnoCrupier()
        }
    }
    
    func turnoCrupier() async {
        state = .dealerTurn
        while dealerHand.total < 17 {
            try? await Task.sleep(for: .milliseconds(350))
            repartir(a: &dealerHand)
        }
        terminar()
    }
    

    func apostar(_ cantidad: Int) async {
        saldo -= cantidad     // descuento único aquí
        await nuevaPartida()
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
    
    func doblar() async {
        saldo -= apuesta
        apuesta += apuesta
        repartir(a: &manosJugador[manoActiva])
        await plantarse()
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
    
    func decidirSeguro(comprar: Bool) async{
        if comprar {
            seguro = apuesta / 2
            saldo -= seguro
            if dealerHand.isBlackjack && seguro > 0 {
                saldo += seguro * 3
            }
        }
        state = .playerTurn
        await revelarBlackjackInicial()
    }
    
    func dividir() async {
        repartiendo = true
        defer { repartiendo = false }
        saldo -= apuesta
        let cartaUno = manosJugador[manoActiva].cards[0]
        let cartaDos = manosJugador[manoActiva].cards[1]
        var manoUno = Hand()
        var manoDos = Hand()
        manoUno.add(cartaUno)
        manoDos.add(cartaDos)
        manosJugador = [manoUno, manoDos]
        try? await Task.sleep(for: .milliseconds(350))
        repartir(a: &manosJugador[0])
        try? await Task.sleep(for: .milliseconds(350))
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
