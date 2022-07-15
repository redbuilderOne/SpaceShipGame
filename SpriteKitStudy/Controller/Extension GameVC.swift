//
//  Extension GameVC.swift
//  SpriteKitStudy
//
//  Created by Дмитрий Скворцов on 14.07.2022.
//

import Foundation

extension GameViewController: PauseViewControllerDelegate {
    func pauseViewControllerSoundButton(_ viewController: PauseViewController) {
        gameScene.soundOn = !gameScene.soundOn
        gameScene.checkMusic()
        let text = gameScene.soundOn ? "ON" : "OFF"
        viewController.soundButton.setTitle(text, for: .normal)
    }

    func pauseViewControllerMusicButton(_ viewController: PauseViewController) {
        gameScene.musicOn = !gameScene.musicOn
        gameScene.checkMusic()
        let text = gameScene.musicOn ? "ON" : "OFF"
        viewController.musicButton.setTitle(text, for: .normal)
    }

    func pauseViewControllerPlayButton(_ viewController: PauseViewController) {
        hidePauseScreen(pauseViewController)
    }
}
