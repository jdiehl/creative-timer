//
//  StepsViewController.swift
//  Timer
//
//  Created by Jonathan Diehl on 19.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class StepsViewController: UIViewController, StepsViewDelegate {
  
  @IBOutlet weak var currentTimeLabel: UILabel!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var stepsView: StepsView!
  
  private let runner = ProgramRunner.shared
  
  private var wasRunning = false
    
  // MARK: - StepsViewDelegate

  func willChangeStep() {
    wasRunning = runner.running
    runner.stop()
  }
  
  func updateStep(to: Int) {
    runner.set(step: to, time: 0)
  }
  
  func didChangeStep(to: Int) {
    runner.set(step: to, time: 0)
    if wasRunning { runner.start() }
  }

  // MARK: - UIViewController
  
  override func viewDidLoad() {
    runner.on(.programChanged) { self.updateSteps() }
    runner.on(.stepChanged) { self.updateProgress() }
    runner.on(.tick) { self.updateProgress() }
    TintManager.shared.on(.tintChanged) { self.updateColor() }
    updateColor()
  }
  
  private func updateSteps() {
    guard let program = runner.program else { return }
    totalTimeLabel.text = program.totalLength.toTimeString()
    stepsView.program = program
  }
  
  private func updateProgress() {
    currentTimeLabel.text = runner.totalTime.toTimeString()
    stepsView.index = runner.index
  }
  
  private func updateColor() {
    view.backgroundColor = TintManager.shared.backgroundColor
    currentTimeLabel.textColor = TintManager.shared.color
    totalTimeLabel.textColor = TintManager.shared.color
  }

}
