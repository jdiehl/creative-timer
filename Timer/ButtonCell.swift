//
//  ButtonCell.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 19.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
  
  var onTap: (() -> Void)?
  
  @IBOutlet weak var button: UIButton!
  
  @objc func onButtonTap() {
    onTap?()
  }
  
  override func awakeFromNib() {
    button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
  }
}
