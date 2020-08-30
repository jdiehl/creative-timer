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
  @IBOutlet weak var pauseView: UIImageView!
  @IBOutlet weak var progressView: ProgressView!

  private let runner = ProgramRunner.shared

  private var wasRunning: Bool?
  
  // MARK: - UIViewController
  
  override func viewDidLoad() {
    runner.on(.programChanged) { self.updateColor() }
    runner.on(.tick) { self.update(animated: self.runner.running) }
    runner.on(.stepChanged) { self.updateStep() }
    updateColor()
    updateStep()
    update(animated: false)
  }
  
  // MARK: - Private Methods
  
  private func update(animated: Bool) {
    if runner.program.direction == .up {
      progressView.set(progress: runner.index.stepProgress, animated: animated)
      progressLabel.text = runner.index.stepTime.toTimeString()
    } else {
      progressView.set(progress: 1 - runner.index.stepProgress, animated: animated)
      let length = runner.index.state == .pause ? runner.program.pause : runner.step.length
      progressLabel.text = (length - runner.index.stepTime).toTimeString()
    }
  }
  
  private func updateStep() {
    if runner.index.state == .pause {
      pauseView.alpha = 1
      UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.autoreverse, .repeat], animations: {
        self.pauseView.alpha = 0.5
      })
    } else {
      pauseView.layer.removeAllAnimations()
      pauseView.alpha = 0
    }
    update(animated: false)
  }
  
  private func updateColor() {
    view.backgroundColor = runner.program.tint.backgroundColor
    progressLabel.textColor = runner.program.tint.foregroundColor
    pauseView.tintColor = runner.program.tint.foregroundColor
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
