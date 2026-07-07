//
//  BlackjackGameTests.swift
//  BlackjackGameTests
//
//  Created by Juanjo on 03/07/2026.
//

import Testing
@testable import BlackjackGame

struct BlackjackGameTests {

    @Test func laBarajaTiene52Cartas() {
        let deck = Deck()
        #expect(deck.cards.count == 52)
    }
    
    @Test func elAsSeAjustaParaNoPasarse() {
        #expect(mano([.AS, .siete]).total == 18)
        #expect(mano([.AS, .siete, .ocho]).total == 16)
        #expect(mano([.AS, .AS, .nueve]).total == 21)
        #expect(mano([.AS, .AS, .diez, .diez]).total == 22)
    }
    
    @Test func laManoSePaso() {
        #expect(mano([.K, .diez, .diez]).isBust == true)
        #expect(mano([.K, .cinco]).isBust == false)
    }
    
    @Test func laManoEsBlackjac() {
        #expect(mano([.K, .AS]).isBlackjack == true)
        #expect(mano([.AS, .cinco, .cinco]).isBlackjack == false)
    }
    
    @Test func ganarSumaLaApuesta() {
        // 1. PREPARAR: montar la situación
        let juego = BlackjackGame()
        juego.saldo = 100
        juego.apuesta = 10
        // damos al jugador 20 y al crupier 17
        juego.playerHand.add(Card(palo: .picas, valor: .K))
        juego.playerHand.add(Card(palo: .picas, valor: .diez))
        juego.dealerHand.add(Card(palo: .corazones, valor: .K))
        juego.dealerHand.add(Card(palo: .corazones, valor: .siete))
        juego.state = .finished        // resolver() necesita que sea finished

        // 2. ACTUAR: ejecutar lo que probamos
        juego.resolver()

        // 3. COMPROBAR: el saldo debe subir en 2x la apuesta
        #expect(juego.saldo == 120)    // 100 + 10*2
        
    }
    
    @Test func perderNoDevuelveNada() {
        // 1. PREPARAR: montar la situación
        let juego = BlackjackGame()
        juego.saldo = 100
        juego.apuesta = 10
        // damos al jugador 16 y al crupier 17
        juego.playerHand.add(Card(palo: .picas, valor: .K))
        juego.playerHand.add(Card(palo: .picas, valor: .seis))
        juego.dealerHand.add(Card(palo: .corazones, valor: .K))
        juego.dealerHand.add(Card(palo: .corazones, valor: .siete))
        juego.state = .finished        // resolver() necesita que sea finished

        // 2. ACTUAR: ejecutar lo que probamos
        juego.resolver()

        // 3. COMPROBAR: el saldo se queda igual
        #expect(juego.saldo == 100)    // 100
    }
    
    @Test func empateDevuelveLaApuesta() {
        // 1. PREPARAR: montar la situación
        let juego = BlackjackGame()
        juego.saldo = 100
        juego.apuesta = 10
        // damos al jugador 20 y al crupier 20
        juego.playerHand.add(Card(palo: .picas, valor: .K))
        juego.playerHand.add(Card(palo: .picas, valor: .diez))
        juego.dealerHand.add(Card(palo: .corazones, valor: .K))
        juego.dealerHand.add(Card(palo: .corazones, valor: .diez))
        juego.state = .finished        // resolver() necesita que sea finished

        // 2. ACTUAR: ejecutar lo que probamos
        juego.resolver()

        // 3. COMPROBAR: el saldo debe subir la apuesta
        #expect(juego.saldo == 110)    // 100 + 10
    }
    
    @Test func blackjackNaturalPaga3de2() {
        // 1. PREPARAR: montar la situación
        let juego = BlackjackGame()
        juego.saldo = 100
        juego.apuesta = 10
        // damos al jugador 21 natural (BLACKJACK) y al crupier 17
        juego.playerHand.add(Card(palo: .picas, valor: .K))
        juego.playerHand.add(Card(palo: .picas, valor: .AS))
        juego.dealerHand.add(Card(palo: .corazones, valor: .K))
        juego.dealerHand.add(Card(palo: .corazones, valor: .siete))
        juego.state = .finished        // resolver() necesita que sea finished

        // 2. ACTUAR: ejecutar lo que probamos
        juego.resolver()

        // 3. COMPROBAR: el saldo debe subir en 2.5x la apuesta
        #expect(juego.saldo == 125)    // 100 + 10 * 5 / 2
    }
    
    @Test func dobleBlackjacEsEmpate() {
        // 1. PREPARAR: montar la situación
        let juego = BlackjackGame()
        juego.saldo = 100
        juego.apuesta = 10
        // damos al jugador BLACKJACK y AL dealer BLACKJACK
        juego.playerHand.add(Card(palo: .picas, valor: .K))
        juego.playerHand.add(Card(palo: .picas, valor: .AS))
        juego.dealerHand.add(Card(palo: .corazones, valor: .J))
        juego.dealerHand.add(Card(palo: .corazones, valor: .AS))
        juego.state = .finished        // resolver() necesita que sea finished

        // 2. ACTUAR: ejecutar lo que probamos
        juego.resolver()

        // 3. COMPROBAR: el saldo debe subir la apuesta
        #expect(juego.saldo == 110)    // 100 + 10
    }
    
    @Test func doblarApuestaEsApostarDoble() {
        // 1. PREPARAR: montar la situación
        let juego =  BlackjackGame()
        juego.saldo = 100
        juego.apuesta = 10
        
        juego.playerHand.add(Card(palo: .picas, valor: .K))
        juego.playerHand.add(Card(palo: .picas, valor: .dos))
        
        // 2. ACTUAR: doblamos
        juego.doblar()
        
        // 3. COMPROBAR
        #expect(juego.apuesta == 20)
        #expect(juego.playerHand.cards.count == 3)
        
    }
    
    func mano(_ valores: [Valor]) -> Hand {
        var h = Hand()
        for v in valores { h.add(Card(palo:.picas, valor: v)) }
        return h
    }

}
