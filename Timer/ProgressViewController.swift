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
  }
  
  // MARK: - Private Methods
  
  private func update() {
    progressView.progress = runner.stepProgress
    progressLabel.text = runner.stepTime.toTimeString()
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
 
  private func updateColor() {
    guard let tint = runner.program?.tint else { return }
    view.backgroundColor = tint.backgroundColor
    progressLabel.textColor = tint.foregroundColor
    progressView.tint = tint
  }

}
