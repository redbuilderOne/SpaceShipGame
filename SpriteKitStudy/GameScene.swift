//
//  GameScene.swift
//  SpriteKitStudy
//
//  Created by Дмитрий Скворцов on 11.07.2022.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {

    let spaceShipCategory: UInt32 = 0x1 << 0 // битовая маска 0
    let asteroidCategory: UInt32 = 0x1 << 1 // битовая маска 1
    let gameViewController = GameViewController()
    let gameOverViewController = GameOverViewController()

    var actions: Actions!

    //    var asteroid: Asteroid = Asteroid()
    var asteroid: Asteroid = Asteroid()
    var score = 0
    var life = 3

    let spriteNodes: SpriteNodes = SpriteNodes()

    var spaceBackground: SKSpriteNode!
    var scoreLabel: SKLabelNode!

    var gameIsPaused = false

    var asteroidLayer: SKNode!
    var starsLayer: SKNode!
    var spaceShipLayer: SKNode!

    var musicSoundPlayer: MusicSoundPlayer!

    func pauseTheGame() {
        gameIsPaused = true
        self.asteroidLayer.isPaused = true
        physicsWorld.speed = 0
        starsLayer.isPaused = true
        musicSoundPlayer.musicPlayer.pause()
        musicSoundPlayer.checkMusic()
    }

    func unpauseTheGame() {
        gameIsPaused = false
        self.asteroidLayer.isPaused = false
        physicsWorld.speed = 1
        starsLayer.isPaused = false
        musicSoundPlayer.musicPlayer.play()
        musicSoundPlayer.checkMusic()
    }

    private func resetTheGame() {
        score = 0
        scoreLabel.text = "Score: \(score)"
        gameIsPaused = false
        self.asteroidLayer.isPaused = false
        physicsWorld.speed = 1
    }

    override func didMove(to view: SKView) {
        collisionsSet()
        musicSoundPlayer = MusicSoundPlayer()
        musicSoundPlayer.playMusic()
        actions = Actions()

        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.8)
        scene?.size = UIScreen.main.bounds.size

        scoreLabel = SKLabelNode(text: "Score: \(score)")

        spriteNodes.heartLife1.position = CGPoint(x: +25, y: -250)
        spriteNodes.heartLife2.position = CGPoint(x: 0, y: -250)
        spriteNodes.heartLife3.position = CGPoint(x: -25, y: -250)

        let colorActionRepeat = SKAction.repeatForever(actions.addSequence(actions.colorAction1, actions.colorAction2))
        spriteNodes.spaceShipModel.run(colorActionRepeat)

        spaceShipLayer = SKNode()
        spaceShipLayer.position = CGPoint(x: frame.midX, y: frame.height / 4)

        guard let firePath = Bundle.main.path(forResource: "Fire", ofType: "sks") else { return }
        guard let fireEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: firePath) as? SKEmitterNode else { return }
        fireEmitter.position.y = -40
        fireEmitter.targetNode = self // шлейф

        let asteroidCreate = SKAction.run {
            let asteroid = self.asteroid.createAsteroid()
            self.asteroidLayer.addChild(asteroid)
            asteroid.position.x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 6))
            asteroid.position.y = self.frame.size.height + asteroid.size.height // создает астероид там где самая верхняя точка экрана
            let asteroidSpeedX: CGFloat = 100.0
            asteroid.physicsBody?.angularVelocity = CGFloat(drand48() * 2 - 1) * 3 // drand48 генерирует Float 0.1...1.0
            asteroid.physicsBody?.velocity.dx = CGFloat(drand48() * 2 - 1) * asteroidSpeedX
            asteroid.zPosition = 2
        }

        asteroidLayer = SKNode()

        let asteroidsPerSecond: Double = 2
        let asteroidCreationDelay = SKAction.wait(forDuration: 1.0 / asteroidsPerSecond, withRange: 0.5)
        let asteroidSequenceAction = SKAction.sequence([asteroidCreate, asteroidCreationDelay]) // объединяем actions в один sequence массив
        let asteroidRunAction = SKAction.repeatForever(asteroidSequenceAction) // повторяем бесконечно этот цикл

        self.asteroidLayer.run(asteroidRunAction) // запускаем action

        spaceBackground = SKSpriteNode(imageNamed: "spaceBackground")
        spaceBackground.size = CGSize(width: frame.size.width + 50, height: frame.size.height + 50)

        // stars
        guard let starsPath = Bundle.main.path(forResource: "Stars", ofType: "sks") else { return }// sks - расширение Stars.sks
        guard let starsEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: starsPath) as? SKEmitterNode else { return }

        starsEmitter.position = CGPoint(x: frame.midX, y: frame.height / 2) // по x - середина
        starsEmitter.particlePositionRange.dx = frame.width
        starsEmitter.advanceSimulationTime(10)

        starsLayer = SKNode()

        // addChild
        addChild(spaceBackground)
        addChild(scoreLabel)
        addChild(spriteNodes.heartLife1)
        addChild(spriteNodes.heartLife2)
        addChild(spriteNodes.heartLife3)
        spaceShipLayer.addChild(spriteNodes.spaceShipModel)
        addChild(spaceShipLayer)
        spaceShipLayer.addChild(fireEmitter)
        addChild(asteroidLayer)
        addChild(starsLayer)
        starsLayer.addChild(starsEmitter)

        // порядок загрузки
        spaceBackground.zPosition = 0
        fireEmitter.zPosition = 0
        starsEmitter.zPosition = 1
        starsLayer?.zPosition = 1
        spriteNodes.spaceShipModel.zPosition = 1
        spriteNodes.heartLife1.zPosition = 1
        spriteNodes.heartLife2.zPosition = 1
        spriteNodes.heartLife3.zPosition = 1
        asteroidLayer.zPosition = 2
        scoreLabel.zPosition = 3
        spaceShipLayer.zPosition = 3
    }

    private func collisionsSet() {
        spriteNodes.spaceShipModel.physicsBody?.categoryBitMask = spaceShipCategory
        spriteNodes.spaceShipModel.physicsBody?.collisionBitMask = asteroidCategory
        spriteNodes.spaceShipModel.physicsBody?.contactTestBitMask = asteroidCategory // регистрируем столкновение
        asteroid.physicsBody?.categoryBitMask = asteroidCategory
        asteroid.physicsBody?.collisionBitMask = spaceShipCategory | asteroidCategory // с кем сталкиваемся
        asteroid.physicsBody?.contactTestBitMask = spaceShipCategory
    }

    // MARK: - TOUCHESBEGAN
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if !gameIsPaused {
                // 4. Определяем точку прикосновения
                let touchLocation = touch.location(in: self)
                print("touchLocation = \(touchLocation)")

                let distance = distanceCalculate(a: spriteNodes.spaceShipModel.position, b: touchLocation) // определяем дистанцию
                let speed: CGFloat = 400
                let time = timeToTravelDistance(distance: distance, speed: speed)

                // 5. Создаем действие для корабля
                let moveAction = SKAction.move(to: touchLocation, duration: time)
                moveAction.timingMode = SKActionTimingMode.easeInEaseOut
                print("distance = \(distance), speed = \(speed), time = \(time)")

                // 6. Придаем созданное действие кораблю - перемещение по координату
                spaceShipLayer.run(moveAction)

                // action для background
                let bgMoveAction = SKAction.move(to: CGPoint(x: -touchLocation.x / 100, y: -touchLocation.y / 100), duration: time)
                spaceBackground.run(bgMoveAction)
            }
        }
    }

    override func didSimulatePhysics() { // метод вызывается после того как создается физический элемент
        asteroidLayer.enumerateChildNodes(withName: "asteroid") { (asteroid, stop) in
            let heightScreen = UIScreen.main.bounds.height // достаем высоту нашего экрана
            if asteroid.position.y < -heightScreen {
                asteroid.removeFromParent()
                self.score = self.score + 1
                self.scoreLabel.text = "Score: \(self.score)"
            }
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        print("contact didBegin")

        let contactLocation = contact.contactPoint
        explosionHappened(position: contactLocation)

        print("contact \(contact)")

        self.score -= 1
        if self.score < 0 {
            self.score = 0
        }

        self.life -= 1

        asteroidLayer.enumerateChildNodes(withName: "asteroid") { (asteroid, stop) in
            asteroid.removeFromParent()
            self.spriteNodes.spaceShipModel.run(self.actions.colorAction3)
        }

        print("life = \(self.life)")
        self.scoreLabel.text = "Score: \(self.score)"

        switch life {
        case 2:
            spriteNodes.heartLife1.isHidden = true
        case 1:
            spriteNodes.heartLife2.isHidden = true
        case 0:
            spriteNodes.heartLife3.isHidden = true
        default:
            GameOverChecker.shared.gameOver = true
            print("Game over? \(GameOverChecker.shared.gameOver)")
//
//            if GameOverChecker.shared.gameOver {
//                gameViewController.showScreen(gameOverViewController)
//            }
        }

        if musicSoundPlayer.soundOn {
            run(actions.hitSoundAction1)
        }
    }


    func didEnd(_ contact: SKPhysicsContact) {
        print("contact didEnd")

        if musicSoundPlayer.soundOn {
            run(actions.beepSoundAction1)
        }
    }
}
