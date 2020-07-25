//
//  ProgramCell.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 25.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class ProgramCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  
  func set(program: Program) {
    titleLabel.text = program.title
  }
  
}
