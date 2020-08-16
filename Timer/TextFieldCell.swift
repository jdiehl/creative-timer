//
//  TextFieldCell.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 16.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell, UITextFieldDelegate {
  
  var textDidChange: ((String) -> Void)?

  @IBOutlet weak var textField: UITextField!
  
  // MARK: - UITextFieldDelegate
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    textDidChange?(textField.text ?? "")
  }

}
