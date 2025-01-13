//
//  GameSound.swift
//  2048Game
//
//  Created by IvanM3 on 12.01.2025.
//
import AVFoundation

var audioPlayer: AVAudioPlayer?

func playMoveSound() {
    if let soundURL = Bundle.main.url(forResource: "move_sound", withExtension: "mp3") {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
}
