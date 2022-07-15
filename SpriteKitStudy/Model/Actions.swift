//
//  Actions.swift
//  SpriteKitStudy
//
//  Created by Дмитрий Скворцов on 15.07.2022.
//

import Foundation
import SpriteKit

struct Actions {

    let hitSoundAction1 = SKAction.playSoundFileNamed("Impact1", waitForCompletion: true)
    let beepSoundAction1 = SKAction.playSoundFileNamed("Beeps1", waitForCompletion: true)
    let colorAction1 = SKAction.colorize(with: .blue, colorBlendFactor: 1, duration: 1)
    let colorAction2 = SKAction.colorize(with: .white, colorBlendFactor: 0, duration: 1)
    let colorAction3 = SKAction.colorize(with: .red, colorBlendFactor: 0, duration: 0.5)

    func addSequence(_ sequence1: SKAction, _ sequence2: SKAction) -> SKAction {
        let sequenceAnimation = SKAction.sequence([sequence1, sequence1])
        return sequenceAnimation
    }

    
}
