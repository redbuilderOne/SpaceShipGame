//
//  ScoreLabel.swift
//  SpriteKitStudy
//
//  Created by Дмитрий Скворцов on 11.07.2022.
//

import Foundation
import SpriteKit

class ScoreLabel: SKLabelNode {

    func createScoreLabel(score: Int) -> SKLabelNode {
        let scoreLabel = SKLabelNode(text: "Score: \(score)")
        return scoreLabel
    }
}
