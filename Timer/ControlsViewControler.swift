//
//  ControlsViewControler.swift
//  Timer
//
//  Created by Jonathan Diehl on 13.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

protocol ControlsDelegate: AnyObject {
  func onSettings()
}

class ControlsViewController: UIViewController {
  
  @IBOutlet weak var resetButton: UIButton!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var pauseButton: UIButton!
  @IBOutlet weak var settingsButton: UIButton!
  
  weak var delegate: ControlsDelegate?

  private let runner = ProgramRunner.shared
  
  // MARK: - IBActions

  @IBAction func onReset(_ sender: AnyObject? = nil) {
    runner.reset()
  }
  
  @IBAction func onPlay(_ sender: AnyObject) {
    runner.start()
  }

  @IBAction func onPause(_ sender: AnyObject) {
    runner.stop()
  }

  @IBAction func onSettings(_ sender: UIView) {
    if runner.running { runner.stop() }
    delegate?.onSettings()
  }

  // MARK: - UIViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    runner.on(.programChanged) { self.updateColor() }
    runner.on(.started) { self.updatePlayPause() }
    runner.on(.stopped) { self.updatePlayPause() }
    updatePlayPause()
    updateColor()
  }
  
  // MARK: - Private Methods
  
  private func updatePlayPause() {
    playButton.isHidden = runner.running
    pauseButton.isHidden = !runner.running
  }
  
  private func updateColor() {
    view.backgroundColor = runner.program.tint.backgroundColor
    resetButton.tintColor = runner.program.tint.foregroundColor
    playButton.tintColor = runner.program.tint.foregroundColor
    pauseButton.tintColor = runner.program.tint.foregroundColor
    settingsButton.tintColor = runner.program.tint.foregroundColor
  }

}
