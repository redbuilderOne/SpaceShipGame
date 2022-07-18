//
//  GameScene (EXT).swift
//  SpriteKitStudy
//
//  Created by Дмитрий Скворцов on 18.07.2022.
//

import Foundation
import SpriteKit

extension GameScene {

    // MARK: Explosion
    func explosionHappened(position: CGPoint) {
        guard let explosion = SKEmitterNode.init(fileNamed: "ShapeExplodes") else { return }
        explosion.position = position

        let explodeAction = SKAction.run({
            self.addChild(explosion)
        })

        let wait = SKAction.wait(forDuration: 0.2)

        let removeExplodeAction = SKAction.run({
            explosion.removeFromParent()
        })
        let explodeSequence = SKAction.sequence([explodeAction, wait, removeExplodeAction])

        self.run(explodeSequence)
    }

    // MARK: Distance Calculate
    func distanceCalculate(a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt((b.x - a.x)*(b.x - a.x) + (b.y - a.y)*(b.y - a.y)) // теорема пифагора
    }

    func timeToTravelDistance(distance: CGFloat, speed: CGFloat) -> TimeInterval {
        let time = distance / speed
        return TimeInterval(time)
    }
    
}
