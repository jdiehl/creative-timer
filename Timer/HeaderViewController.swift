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
    updateProgram()
  }
  
  private func updateProgram() {
    view.backgroundColor = runner.program.tint.backgroundColor
    stepLabel.textColor = runner.program.tint.foregroundColor
    programLabel.textColor = runner.program.tint.foregroundColor
    programLabel.text = runner.program.title
    updateStep()
  }
  
  private func updateStep() {
    self.stepLabel.text = runner.stepTitle
  }
  
}
