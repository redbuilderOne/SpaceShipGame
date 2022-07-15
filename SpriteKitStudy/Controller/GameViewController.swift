//
//  GameViewController.swift
//  SpriteKitStudy
//
//  Created by Дмитрий Скворцов on 11.07.2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var gameScene: GameScene!
    var pauseViewController: PauseViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        pauseViewController = storyboard?.instantiateViewController(withIdentifier: "PauseViewController") as? PauseViewController
        pauseViewController.delegate = self

        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill

                gameScene = scene as? GameScene
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        gameScene.pauseTheGame()
        showPauseScreen(pauseViewController)
    }

    func hidePauseScreen(_ viewController: PauseViewController) {
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        gameScene.unpauseTheGame()

        viewController.view.alpha = 0.5

        UIView.animate(withDuration: 0.5, animations: {
            viewController.view.alpha = 0
        }, completion: {_ in
            viewController.view.removeFromSuperview()
        }
        )}

    private func showPauseScreen(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds

        viewController.view.alpha = 0
        UIView.animate(withDuration: 0.5) {
            viewController.view.alpha = 0.5
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
