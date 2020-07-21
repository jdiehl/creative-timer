//
//  ControlsViewControler.swift
//  Timer
//
//  Created by Jonathan Diehl on 13.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit
import FontAwesome

protocol ControlsDelegate: AnyObject {
  func onSettings()
}

class ControlsViewController: UIViewController {
  
  @IBOutlet weak var resetButton: UIButton!
  @IBOutlet weak var playPauseButton: UIButton!
  @IBOutlet weak var settingsButton: UIButton!
  
  weak var delegate: ControlsDelegate?

  private let runner = ProgramRunner.shared
  
  private var font: UIFont { UIFont.fontAwesome(ofSize: 18, style: .solid) }

  // MARK: - IBActions

  @IBAction func onReset(_ sender: AnyObject? = nil) {
    runner.reset()
  }
  
  @IBAction func onPlayPause(_ sender: AnyObject) {
    runner.running ? runner.stop() : runner.start()
  }

  @IBAction func onSettings(_ sender: UIView) {
    delegate?.onSettings()
  }

  // MARK: - UIViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupEvents()
    setupButtons()
    updatePlayPause()
    updateColor()
  }
  
  // MARK: - Private Methods
  
  private func setupEvents() {
    runner.on(.started) { self.updatePlayPause() }
    runner.on(.stopped) { self.updatePlayPause() }
    TintManager.shared.on(.tintChanged) { self.updateColor() }
  }
  
  private func updatePlayPause() {
    let name: FontAwesome = runner.running ? .pause : .play
    playPauseButton.setTitle(String.fontAwesomeIcon(name: name), for: .normal)
  }
  
  private func setupButtons() {
    resetButton.titleLabel?.font = font
    playPauseButton.titleLabel?.font = font
    settingsButton.titleLabel?.font = font
    
    playPauseButton.setTitle(String.fontAwesomeIcon(name: .undo), for: .normal)
    playPauseButton.setTitle(String.fontAwesomeIcon(name: .play), for: .normal)
    settingsButton.setTitle(String.fontAwesomeIcon(name: .ellipsisV), for: .normal)
  }
  
  private func updateColor() {
    self.view.backgroundColor = TintManager.shared.backgroundColor
    resetButton.setTitleColor(TintManager.shared.color, for: .normal)
    playPauseButton.setTitleColor(TintManager.shared.color, for: .normal)
    settingsButton.setTitleColor(TintManager.shared.color, for: .normal)
  }

}
