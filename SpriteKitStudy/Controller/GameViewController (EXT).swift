//
//  Extension GameVC.swift
//  SpriteKitStudy
//
//  Created by Дмитрий Скворцов on 14.07.2022.
//

import Foundation

extension GameViewController: PauseViewControllerDelegate {
    func pauseViewControllerSoundButton(_ viewController: PauseViewController) {
        gameScene.musicSoundPlayer.soundOn = !gameScene.musicSoundPlayer.soundOn
        gameScene.musicSoundPlayer.checkMusic()
        let text = gameScene.musicSoundPlayer.soundOn ? "ON" : "OFF"
        viewController.soundButton.setTitle(text, for: .normal)
    }

    func pauseViewControllerMusicButton(_ viewController: PauseViewController) {
        gameScene.musicSoundPlayer.musicOn = !gameScene.musicSoundPlayer.musicOn
        gameScene.musicSoundPlayer.checkMusic()
        let text = gameScene.musicSoundPlayer.musicOn ? "ON" : "OFF"
        viewController.musicButton.setTitle(text, for: .normal)
    }

    func pauseViewControllerPlayButton(_ viewController: PauseViewController) {
        hidePauseScreen(pauseViewController)
    }
}
