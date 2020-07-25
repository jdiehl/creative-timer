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
    runner.on(.tick) { self.update() }
    TintManager.shared.on(.tintChanged) { self.updateColor() }
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
    view.backgroundColor = TintManager.shared.backgroundColor
    progressLabel.textColor = TintManager.shared.color
  }

}
