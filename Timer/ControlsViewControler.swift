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
    if runner.running { runner.stop() }
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
    runner.on(.programChanged) { self.updateColor() }
    runner.on(.started) { self.updatePlayPause() }
    runner.on(.stopped) { self.updatePlayPause() }
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
    guard let tint = ProgramRunner.shared.program?.tint else { return }
    view.backgroundColor = tint.backgroundColor
    resetButton.setTitleColor(tint.foregroundColor, for: .normal)
    playPauseButton.setTitleColor(tint.foregroundColor, for: .normal)
    settingsButton.setTitleColor(tint.foregroundColor, for: .normal)
  }

}
