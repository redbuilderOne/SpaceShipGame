//
//  MusicPlayer.swift
//  SpriteKitStudy
//
//  Created by Дмитрий Скворцов on 15.07.2022.
//

import Foundation
import AVFoundation

class MusicSoundPlayer {

    var musicPlayer = AVAudioPlayer()
    var musicOn = true
    var soundOn = true

    func checkMusic() {
        if musicOn {
            musicPlayer.play()
        } else {
            musicPlayer.stop()
        }
    }

    func playMusic() {
        if let musicPad = Bundle.main.url(forResource: "MainTheme", withExtension: "mp3") {
            musicPlayer = try! AVAudioPlayer(contentsOf: musicPad, fileTypeHint: nil)
            musicPlayer.play()
            musicPlayer.numberOfLoops = -1 // если отрицательное значение, то играет бесконечно
            musicPlayer.volume = 0.2
        }
        checkMusic()
    }
}
