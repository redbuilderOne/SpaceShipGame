//
//  PauseViewController.swift
//  SpriteKitStudy
//
//  Created by Дмитрий Скворцов on 14.07.2022.
//

import UIKit

protocol PauseViewControllerDelegate {
    func pauseViewControllerPlayButton(_ viewController: PauseViewController)
    func pauseViewControllerSoundButton(_ viewController: PauseViewController)
    func pauseViewControllerMusicButton(_ viewController: PauseViewController)
}

class PauseViewController: UIViewController {

    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!

    var delegate: PauseViewControllerDelegate!

    @IBAction func playButtonPressed(_ sender: Any) {
        delegate.pauseViewControllerPlayButton(self)
    }

    @IBAction func soundButtonPressed(_ sender: UIButton) {
        delegate.pauseViewControllerSoundButton(self)
    }

    @IBAction func musicButtonPressed(_ sender: UIButton) {
        delegate.pauseViewControllerMusicButton(self)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.opacity = 0.5
    }
}
