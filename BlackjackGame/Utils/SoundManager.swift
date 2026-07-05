//
//  SoundManager.swift
//  BlackjackGame
//
//  Created by Juanjo on 04/07/2026.
//
import AudioToolbox

enum Sonido {
    static let carta: SystemSoundID = 1104
    static let ganar: SystemSoundID = 1025
    static let perder: SystemSoundID = 1053
    
    static func reproducir(_ id: SystemSoundID) {
        AudioServicesPlaySystemSound(id)
    }
}
