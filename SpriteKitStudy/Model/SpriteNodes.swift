//
//  SpriteNodes.swift
//  SpriteKitStudy
//
//  Created by Дмитрий Скворцов on 18.07.2022.
//

import Foundation
import SpriteKit

struct SpriteNodes {
    
    var spaceShipModel: SKSpriteNode = {
        var spaceShip = SKSpriteNode()
        spaceShip = SKSpriteNode(imageNamed: "greySpaceShip")
        spaceShip.xScale = 0.8
        spaceShip.yScale = 0.8
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size) // придаем физическое тело: текстуру и вес
        spaceShip.physicsBody?.isDynamic = false // тело не будет падать вниз
        return spaceShip
    }()

    // MARK: Lives
    var heartLife1: SKSpriteNode = {
        var heartLife = SKSpriteNode()
        heartLife = SKSpriteNode(imageNamed: "heart")
        heartLife.xScale = 0.3
        heartLife.yScale = 0.3
        return heartLife
    }()

    var heartLife2: SKSpriteNode = {
        var heartLife = SKSpriteNode()
        heartLife = SKSpriteNode(imageNamed: "heart")
        heartLife.xScale = 0.3
        heartLife.yScale = 0.3
        return heartLife
    }()

    var heartLife3: SKSpriteNode = {
        var heartLife = SKSpriteNode()
        heartLife = SKSpriteNode(imageNamed: "heart")
        heartLife.xScale = 0.3
        heartLife.yScale = 0.3
        return heartLife
    }()
}
