//
//  Extension GameVC.swift
//  SpriteKitStudy
//
//  Created by Дмитрий Скворцов on 14.07.2022.
//

import Foundation

extension GameViewController: PauseViewControllerDelegate {
    func pauseViewControllerPlayButton(_ viewController: PauseViewController) {
        hidePauseScreen(pauseViewController)
    }
}
