//
//  ProgramCell.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 25.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class ProgramCell: UITableViewCell {
  
  @IBOutlet weak var panel: PanelView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var stepsView: StepsView!
  
  func set(program: Program) {
    titleLabel.text = program.title
    stepsView.program = program
    titleLabel.textColor = program.tint.foregroundColor
    panel.backgroundColor = program.tint.backgroundColor
  }
}
