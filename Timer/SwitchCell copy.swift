//
//  ButtonCell.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 19.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {
  
  var didChange: ((Bool) -> Void)?
  
  @IBOutlet weak var switchView: UISwitch!
  @IBOutlet weak var label: UILabel!

  @objc func onSwitch() {
    didChange?(switchView.isOn)
  }
  
  override func awakeFromNib() {
    switchView.addTarget(self, action: #selector(onSwitch), for: .valueChanged)
  }
  
  func set(on: Bool, animated: Bool = true) {
    switchView.setOn(on, animated: animated)
  }
  
  func set(label: String) {
    self.label.text = label
  }
}
