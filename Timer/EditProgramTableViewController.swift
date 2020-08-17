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
    case 0: return 2
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
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch (indexPath.section, indexPath.row) {
      case (0, 1): return 60
      default: return 44
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath.section, indexPath.row) {
      case (0, 0): return makeTitleCell(indexPath: indexPath)
      case (0, 1): return makeThemeCell(indexPath: indexPath)
      default: return UITableViewCell()
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
  }

  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  
  // MARK: - Cell Factory
  
  private func makeTitleCell(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
    cell.textField.text = program?.title
    cell.didChange = { self.program?.title = $0 }
    return cell
  }

  private func makeThemeCell(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath) as! ThemeCell
    cell.theme = self.program?.tint.theme
    cell.didChange = { self.program?.tint.theme = $0 }
    return cell
  }

}
