//
//  StepsViewController.swift
//  Timer
//
//  Created by Jonathan Diehl on 19.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class StepsViewController: UIViewController, StepsPickerDelegate {
  
  @IBOutlet weak var currentTimeLabel: UILabel!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var stepsPicker: StepsPicker!
  
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
  }
  
  private func updateSteps() {
    guard let program = runner.program else { return }
    view.backgroundColor = program.tint.backgroundColor
    currentTimeLabel.textColor = program.tint.foregroundColor
    totalTimeLabel.textColor = program.tint.foregroundColor
    totalTimeLabel.text = program.totalLength.toTimeString()
    stepsPicker.program = program
  }
  
  private func updateProgress() {
    currentTimeLabel.text = runner.totalTime.toTimeString()
    stepsPicker.index = runner.index
  }

}
