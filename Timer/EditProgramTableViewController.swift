//
//  EditProgramTableViewController.swift
//  CusTimer
//
//  Created by Jonathan Diehl on 16.08.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

import UIKit

class EditProgramTableViewController: UITableViewController {
  
  var program: Program? {
    didSet { programChanged?(program!) }
  }

  var programChanged: ((Program) -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return 1
    default: return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0: return "Name & Appearance"
    case 1: return "Steps"
    default: return nil
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
    cell.textField.text = program?.title
    cell.textDidChange = { self.program?.title = $0 }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
  }

  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return false
  }

}
