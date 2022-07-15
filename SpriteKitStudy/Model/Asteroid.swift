//
//  Asteroid.swift
//  SpriteKitStudy
//
//  Created by Дмитрий Скворцов on 11.07.2022.
//

import Foundation
import SpriteKit
import GameplayKit

class Asteroid: SKSpriteNode {
    let asteroidCategory: UInt32 = 0x1 << 1 // битовая маска 1

    func createAsteroid() -> SKSpriteNode {
        let asteroid = SKSpriteNode(imageNamed: "asteroid")
//        asteroid.position.x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 6))
//        asteroid.position.y = frame.size.height + asteroid.size.height // создает астероид там где самая верхняя точка экрана

        let randomScale = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 6)) / 10
        asteroid.xScale = randomScale
        asteroid.yScale = randomScale
        asteroid.name = "asteroid"

        asteroid.physicsBody = SKPhysicsBody(texture: asteroid.texture!, size: asteroid.size)

        return asteroid
    }
}
