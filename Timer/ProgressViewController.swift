//
//  MainProgressViewController.swift
//  Timer
//
//  Created by Jonathan Diehl on 16.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController, ProgressViewDelegate {
  
  @IBOutlet weak var progressLabel: UILabel!
  @IBOutlet weak var progressView: ProgressView!

  private let runner = ProgramRunner.shared

  private var wasRunning: Bool?
  
  // MARK: - UIViewController
  
  override func viewDidLoad() {
    runner.on(.programChanged) { self.updateColor() }
    runner.on(.tick) { self.update() }
    updateColor()
    update()
  }
  
  // MARK: - Private Methods
  
  private func update() {
    if runner.program.direction == .up {
      progressView.progress = runner.index.stepProgress
      progressLabel.text = runner.index.stepTime.toTimeString()
    } else {
      progressView.progress = 1 - runner.index.stepProgress
      let length = runner.index.state == .pause ? runner.program.pause : runner.step.length
      progressLabel.text = (length - runner.index.stepTime).toTimeString()
    }
  }
  
  private func updateColor() {
    view.backgroundColor = runner.program.tint.backgroundColor
    progressLabel.textColor = runner.program.tint.foregroundColor
    progressView.tint = runner.program.tint
  }
  
  private func setProgress(to: Float) {
    if runner.program.direction == .up {
      runner.set(progress: to)
    } else {
      runner.set(progress: 1 - to)
    }
  }

  // MARK: - ProgressViewDelegate
  
  func willChangeProgress() {
    wasRunning = runner.running
    runner.stop()
  }
  
  func updateProgress(to: Float) {
    setProgress(to: to)
  }
  
  func didChangeProgress(to: Float) {
    setProgress(to: to)
    if wasRunning == true { runner.start() }
  }
 
}
