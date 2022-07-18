//
//  GameOverChecker.swift
//  SpriteKitStudy
//
//  Created by Дмитрий Скворцов on 18.07.2022.
//

import Foundation

struct GameOverChecker {
    static var shared = GameOverChecker(gameOver: false)
    var gameOver: Bool
}
