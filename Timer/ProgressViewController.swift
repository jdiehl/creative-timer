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
    progressView.progress = runner.stepProgress
    progressLabel.text = runner.stepTime.toTimeString()
  }
  
  private func updateColor() {
    view.backgroundColor = runner.program.tint.backgroundColor
    progressLabel.textColor = runner.program.tint.foregroundColor
    progressView.tint = runner.program.tint
  }

  // MARK: - ProgressViewDelegate
  
  func willChangeProgress() {
    wasRunning = runner.running
    runner.stop()
  }
  
  func updateProgress(to: Float) {
    runner.set(progress: to)
  }
  
  func didChangeProgress(to: Float) {
    runner.set(progress: to)
    if wasRunning == true { runner.start() }    
  }
 
}
