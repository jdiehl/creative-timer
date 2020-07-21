//
//  HeaderViewController.swift
//  Timer
//
//  Created by Jonathan Diehl on 17.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class HeaderViewController: UIViewController {
  
  @IBOutlet weak var programLabel: UILabel!
  @IBOutlet weak var stepLabel: UILabel!

  private let runner = ProgramRunner.shared
  
  // MARK: - UIViewController
  
  override func viewDidLoad() {
    runner.on(.programChanged) { self.updateProgram() }
    runner.on(.stepChanged) { self.updateStep() }
    TintManager.shared.on(.tintChanged) { self.updateColor() }
    updateColor()
  }
  
  private func updateProgram() {
    guard let program = self.runner.program else { return }
    self.programLabel.text = program.title
    self.updateStep()
  }
  
  private func updateStep() {
    guard let step = self.runner.step else { return }
    self.stepLabel.text = step.title
  }
  
  private func updateColor() {
    self.view.backgroundColor = TintManager.shared.backgroundColor
    self.stepLabel.textColor = TintManager.shared.color
    self.programLabel.textColor = TintManager.shared.color
  }

}
