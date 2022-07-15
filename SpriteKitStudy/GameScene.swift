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

    var actions: Actions!

    var asteroid: Asteroid = Asteroid()
    var score = 0
    var life = 3

    var spaceBackground: SKSpriteNode!
    var scoreLabel: SKLabelNode!

    var gameIsPaused = false

    var asteroidLayer: SKNode!
    var starsLayer: SKNode!
    var spaceShipLayer: SKNode!

    var musicSoundPlayer: MusicSoundPlayer!

//    var musicPlayer: AVAudioPlayer!
//    var musicOn = true
//    var soundOn = true

    var spaceShipModel: SKSpriteNode = {
        var spaceShip = SKSpriteNode()
        spaceShip = SKSpriteNode(imageNamed: "greySpaceShip")
        spaceShip.xScale = 0.8
        spaceShip.yScale = 0.8
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size) // придаем физическое тело: текстуру и вес
        spaceShip.physicsBody?.isDynamic = false // тело не будет падать вниз
        return spaceShip
    }()

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
        musicSoundPlayer = MusicSoundPlayer()
        musicSoundPlayer.playMusic()
        actions = Actions()

        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.8)
        scene?.size = UIScreen.main.bounds.size

        scoreLabel = SKLabelNode(text: "Score: \(score)")
        //        scoreLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height - scoreLabel.calculateAccumulatedFrame().height - 15)
        heartLife1.position = CGPoint(x: +25, y: -250)
        heartLife2.position = CGPoint(x: 0, y: -250)
        heartLife3.position = CGPoint(x: -25, y: -250)

        heartLife1.zPosition = 1
        heartLife2.zPosition = 1
        heartLife3.zPosition = 1

        addChild(scoreLabel)
        addChild(heartLife1)
        addChild(heartLife2)
        addChild(heartLife3)
        collisionsSet()

        let colorActionRepeat = SKAction.repeatForever(actions.addSequence(actions.colorAction1, actions.colorAction2))
        spaceShipModel.run(colorActionRepeat)

        // addChild(spaceShipModel) // 3. Добавляем на экран

        // слой для корабля и огня
        spaceShipLayer = SKNode()
        spaceShipLayer.addChild(spaceShipModel)
        spaceShipLayer.zPosition = 3
        spaceShipModel.zPosition = 1
        spaceShipLayer.position = CGPoint(x: frame.midX, y: frame.height / 4)
        addChild(spaceShipLayer)

        // создаем огонь
        guard let firePath = Bundle.main.path(forResource: "Fire", ofType: "sks") else { return }
        guard let fireEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: firePath) as? SKEmitterNode else { return }
        fireEmitter.zPosition = 0
        fireEmitter.position.y = -40
        fireEmitter.targetNode = self // шлейф
        spaceShipLayer.addChild(fireEmitter)

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
        asteroidLayer.zPosition = 2
        addChild(asteroidLayer)

        let asteroidsPerSecond: Double = 2
        let asteroidCreationDelay = SKAction.wait(forDuration: 1.0 / asteroidsPerSecond, withRange: 0.5)
        let asteroidSequenceAction = SKAction.sequence([asteroidCreate, asteroidCreationDelay]) // объединяем actions в один sequence массив
        let asteroidRunAction = SKAction.repeatForever(asteroidSequenceAction) // повторяем бесконечно этот цикл

        self.asteroidLayer.run(asteroidRunAction) // запускаем action

        spaceBackground = SKSpriteNode(imageNamed: "spaceBackground")
        spaceBackground.size = CGSize(width: frame.size.width + 50, height: frame.size.height + 50)

        addChild(spaceBackground)

        // stars
        guard let starsPath = Bundle.main.path(forResource: "Stars", ofType: "sks") else { return }// sks - расширение Stars.sks
        guard let starsEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: starsPath) as? SKEmitterNode else { return }

        starsEmitter.zPosition = 1
        starsEmitter.position = CGPoint(x: frame.midX, y: frame.height / 2) // по x - середина
        starsEmitter.particlePositionRange.dx = frame.width
        starsEmitter.advanceSimulationTime(10)

        starsLayer = SKNode()
        starsLayer?.zPosition = 1
        addChild(starsLayer)

        starsLayer.addChild(starsEmitter)

        // порядок загрузки
        spaceBackground.zPosition = 0
        scoreLabel.zPosition = 3
    }

    private func collisionsSet() {
        spaceShipModel.physicsBody?.categoryBitMask = spaceShipCategory
        spaceShipModel.physicsBody?.collisionBitMask = asteroidCategory
        spaceShipModel.physicsBody?.contactTestBitMask = asteroidCategory // регистрируем столкновение
        asteroid.physicsBody?.categoryBitMask = asteroidCategory
        asteroid.physicsBody?.collisionBitMask = spaceShipCategory | asteroidCategory // с кем сталкиваемся
        asteroid.physicsBody?.contactTestBitMask = spaceShipCategory
    }

//    private func playMusic() {
//        if let musicPad = Bundle.main.url(forResource: "MainTheme", withExtension: "mp3") {
//            musicSoundPlayer.musicPlayer = try! AVAudioPlayer(contentsOf: musicPad, fileTypeHint: nil)
//            musicSoundPlayer.musicPlayer.play()
//            musicSoundPlayer.musicPlayer.numberOfLoops = -1 // если отрицательное значение, то играет бесконечно
//            musicSoundPlayer.musicPlayer.volume = 0.2
//        }
//        checkMusic()
//    }

    // MARK: - TOUCHESBEGAN
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if !gameIsPaused {
                // 4. Определяем точку прикосновения
                let touchLocation = touch.location(in: self)
                print("touchLocation = \(touchLocation)")

                let distance = distanceCalculate(a: spaceShipModel.position, b: touchLocation) // определяем дистанцию
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

    // MARK: Distance Calculate
    private func distanceCalculate(a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt((b.x - a.x)*(b.x - a.x) + (b.y - a.y)*(b.y - a.y)) // теорема пифагора
    }

    private func timeToTravelDistance(distance: CGFloat, speed: CGFloat) -> TimeInterval {
        let time = distance / speed
        return TimeInterval(time)
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

        self.score -= 1
        self.life -= 1
        print("life = \(self.life)")
        self.scoreLabel.text = "Score: \(self.score)"

        switch life {
        case 2:
            heartLife1.isHidden = true
        case 1:
            heartLife2.isHidden = true
        case 0:
            heartLife3.isHidden = true
        default:
            print("game over")
        }

        asteroidLayer.enumerateChildNodes(withName: "asteroid") { (asteroid, stop) in
            asteroid.removeFromParent()
            self.spaceShipModel.run(self.actions.colorAction3)
        }

        if musicSoundPlayer.soundOn {
            run(actions.hitSoundAction1)
        }
    }


    func didEnd(_ contact: SKPhysicsContact) {
        print("contact didEnd")

        //        let explosion = SKEmitterNode(fileNamed: "Explosion")
        //        explosion?.position =
        // https://www.youtube.com/watch?v=zyly5HhA6ao

        if musicSoundPlayer.soundOn {
            run(actions.beepSoundAction1)
        }
    }
}
